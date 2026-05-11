# ✨ pi-cfg

My personal **pi** agent configuration — packages, skills, and bootstrap scripts to get a full coding-agent environment running on any machine in minutes.

> **[pi](https://github.com/earendil-works/pi)** is an AI coding agent that lives in your terminal.

---

## 🚀 Quick Start

```bash
git clone git@github.com:tsnAnh/pi-cfg.git ~/.pi
cd ~/.pi
chmod +x scripts/setup-pi.sh
./scripts/setup-pi.sh
```

The setup script handles everything:

1. **rtk** — installed via Homebrew
2. **CodeMapper (`cm`)** — built from [source](https://github.com/p1rallels/codemapper) via Cargo
3. **Pi packages** — all packages in `settings.json` installed globally
4. **Skills** — pi-superpowers symlinked into `~/.pi/agent/skills/`

> **Prerequisites:** [Homebrew](https://brew.sh), [Node.js](https://nodejs.org/), and [Rust](https://rustup.rs)

---

## 📦 Packages

| Package | Source | What it does |
|---|---|---|
| **pi-codemapper** | [elpapi42](https://github.com/elpapi42/pi-codemapper) | CodeMapper integration for pi agent |
| **pi-minimal-subagent** | [elpapi42](https://github.com/elpapi42/pi-minimal-subagent) | Lightweight subagent delegation |
| **pi-fork** | [elpapi42](https://github.com/elpapi42/pi-fork) | Fork-based isolated subprocess execution |
| **pi-hooks** | npm | Lifecycle hooks for pi |
| **pi-rtk-optimizer** | npm | Response token optimization |
| **pi-observational-memory** | npm | Memory & recall across sessions |
| **pi-mermaid** | npm | Mermaid diagram generation |
| **amp-themes** | npm | UI themes (dark, light, gruvbox…) |
| **pi-caveman** | [v2nic](https://github.com/v2nic/pi-caveman) | Ultra-compressed comms (~75% fewer tokens) |
| **pi-powerline-footer** | npm | Powerline-style TUI footer |
| **pi-superpowers** | [coctostan](https://github.com/coctostan/pi-superpowers) | Structured workflow skills |

---

## 🧠 Skills

Installed via [pi-superpowers](https://github.com/coctostan/pi-superpowers) and symlinked automatically:

| Skill | Description |
|---|---|
| `brainstorming` | Socratic design refinement |
| `writing-plans` | Implementation plans with TDD tasks |
| `executing-plans` | Batch execution with checkpoints |
| `subagent-driven-development` | Parallel task execution with review |
| `test-driven-development` | RED-GREEN-REFACTOR cycle |
| `systematic-debugging` | 4-phase root cause investigation |
| `verification-before-completion` | Evidence before claims |
| `requesting-code-review` | Pre-merge review workflow |
| `receiving-code-review` | Technical evaluation of feedback |
| `dispatching-parallel-agents` | Concurrent subagent workflows |
| `using-git-worktrees` | Isolated development branches |
| `finishing-a-development-branch` | Merge/PR decision workflow |
| `writing-skills` | TDD for process documentation |

🤖 = uses subagent dispatching

---

## ⚙️ Config

Packages are declared in [`settings.json`](settings.json):

```json
{
  "packages": [
    "npm:pi-hooks",
    "git:github.com/elpapi42/pi-codemapper",
    "git:github.com/coctostan/pi-superpowers"
  ]
}
```

Sources: `npm:<name>` or `git:<repo>`

To add a package — edit the file and re-run `./scripts/setup-pi.sh`.

---

## 📁 Layout

```
~/.pi/
├── scripts/setup-pi.sh   # Bootstrap script
├── settings.json         # Package registry
├── agent/
│   ├── skills/           # → symlinks to installed skills
│   ├── extensions/       # Custom extensions
│   ├── git/              # Git-cloned packages
│   └── sessions/         # Session history
├── git/                  # (ignored) cloned package data
└── npm/                  # (ignored) npm package data
```

---

## 💡 Tips

| Need | Command |
|---|---|
| New machine | `git clone → chmod → ./setup-pi.sh` |
| Add a package | Edit `settings.json` → re-run script |
| Check installs | `pi list` |
| Verify `cm` | `cm stats .` |

---

*Built with ❤️ for the pi community.*
