#!/usr/bin/env bash
set -euo pipefail

ROOT="$(mktemp -d)"
trap 'kill "${SOCKET_PID:-}" 2>/dev/null || true; rm -rf "$ROOT"' EXIT
SYSTEM_PATH="$PATH"
REPO="$ROOT/repo"
HOME_DIR="$ROOT/home"
BIN="$ROOT/bin"
STATE="$ROOT/state"
mkdir -p "$REPO/scripts" "$HOME_DIR/.pi/agent/browser-group/extension" "$BIN" "$STATE"
cp "$(cd "$(dirname "$0")/.." && pwd -P)/scripts/pi-launcher.sh" "$REPO/scripts/pi-launcher.sh"
chmod +x "$REPO/scripts/pi-launcher.sh"

cat > "$REPO/scripts/update-pi.sh" <<'SH'
#!/bin/sh
printf 'update\n' >> "$TEST_UPDATE_LOG"
SH
chmod +x "$REPO/scripts/update-pi.sh"
cat > "$BIN/pi" <<'SH'
#!/bin/sh
printf 'pi\n' >> "$TEST_PI_LOG"
[ -n "${NODE_COMPILE_CACHE:-}" ] && [ -d "$NODE_COMPILE_CACHE" ]
SH
chmod +x "$BIN/pi"
cat > "$BIN/cua-driver" <<'SH'
#!/bin/sh
printf '%s\n' "$*" >> "$TEST_CUA_LOG"
case "$1" in
  --version) printf 'cua-driver 0.28.2\n' ;;
  status) exit 0 ;;
  permissions) printf '{"accessibility":true,"screen_recording":true}\n' ;;
  list-tools) printf 'set_agent_cursor_enabled\n' ;;
esac
SH
chmod +x "$BIN/cua-driver"
cat > "$HOME_DIR/.pi/agent/browser-group/check-bridge.mjs" <<'JS'
process.exit(0);
JS
printf '{"version":"2.0.1"}\n' > "$HOME_DIR/.pi/agent/browser-group/extension/manifest.json"

git -C "$REPO" init -q
git -C "$REPO" config user.name test
git -C "$REPO" config user.email test@example.invalid
git -C "$REPO" add scripts
git -C "$REPO" commit -qm initial

export HOME="$HOME_DIR"
export PATH="$BIN:$SYSTEM_PATH"
export PI_AUTO_UPDATE_STATE_DIR="$STATE"
export PI_AUTO_UPDATE_INTERVAL_SECONDS=21600
export PI_CUA_CHECK_INTERVAL_SECONDS=21600
export PI_BACKGROUND_PREFLIGHT_DELAY_SECONDS=0
export TEST_UPDATE_LOG="$ROOT/update.log"
export TEST_PI_LOG="$ROOT/pi.log"
export TEST_CUA_LOG="$ROOT/cua.log"

python3 - "$HOME_DIR/.pi/agent/browser-group.sock" <<'PY' &
import socket, sys, time
s = socket.socket(socket.AF_UNIX)
s.bind(sys.argv[1])
s.listen()
time.sleep(30)
PY
SOCKET_PID=$!
for _ in 1 2 3 4 5; do [ -S "$HOME_DIR/.pi/agent/browser-group.sock" ] && break; sleep 0.1; done
[ -S "$HOME_DIR/.pi/agent/browser-group.sock" ]

"$REPO/scripts/pi-launcher.sh" >/dev/null 2>"$ROOT/first.err"
"$REPO/scripts/pi-launcher.sh" >/dev/null 2>"$ROOT/cached.err"

[ "$(wc -l < "$TEST_UPDATE_LOG" | tr -d ' ')" = "1" ]
[ "$(wc -l < "$TEST_PI_LOG" | tr -d ' ')" = "2" ]
[ "$(wc -l < "$TEST_CUA_LOG" | tr -d ' ')" = "4" ]
[ ! -s "$ROOT/cached.err" ]

printf '# dirty\n' >> "$REPO/scripts/update-pi.sh"
"$REPO/scripts/pi-launcher.sh" >/dev/null 2>&1
[ "$(wc -l < "$TEST_UPDATE_LOG" | tr -d ' ')" = "1" ]
[ "$(wc -l < "$TEST_CUA_LOG" | tr -d ' ')" = "4" ]

printf '{"version":"2.0.2"}\n' > "$HOME_DIR/.pi/agent/browser-group/extension/manifest.json"
"$REPO/scripts/pi-launcher.sh" >/dev/null 2>&1
[ "$(wc -l < "$TEST_CUA_LOG" | tr -d ' ')" = "4" ]

PI_AUTO_UPDATE_INTERVAL_SECONDS=0 PI_CUA_CHECK_INTERVAL_SECONDS=0 "$REPO/scripts/pi-launcher.sh" >/dev/null 2>&1
[ "$(wc -l < "$TEST_UPDATE_LOG" | tr -d ' ')" = "2" ]
[ "$(wc -l < "$TEST_CUA_LOG" | tr -d ' ')" = "8" ]

printf '1\n' > "$STATE/last-success"
"$REPO/scripts/pi-launcher.sh" >/dev/null 2>"$ROOT/background.err"
[ ! -s "$ROOT/background.err" ]
for _ in 1 2 3 4 5 6 7 8 9 10; do
  [ "$(wc -l < "$TEST_UPDATE_LOG" | tr -d ' ')" = "3" ] && break
  sleep 0.1
done
[ "$(wc -l < "$TEST_UPDATE_LOG" | tr -d ' ')" = "3" ]

printf 'pi launcher cache tests passed\n'
