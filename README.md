# ✨ pi-cfg

Your personal configuration & bootstrap toolkit for **[pi](https://github.com/earendil-works/pi-coding-agent)** — an AI coding agent that lives in your terminal.

This repo stores shared pi settings, community packages, and one-command setup so you can get pi running on any machine in minutes.

---

## 🚀 Quick Start

Clone this repo into your home directory and run the setup script:

```bash
git clone git@github.com:tsnAnh/pi-cfg.git ~/.pi
cd ~/.pi
chmod +x scripts/setup-pi.sh
./scripts/setup-pi.sh
```

That's it! The script will:

1. Install **rtk** via [Homebrew](https://brew.sh)
2. Bootstrap all pi packages listed in `settings.json`
3. Drop everything into your `~/.pi/` directory — ready to go

> **Prerequisites:** [Homebrew](https://brew.sh) and [Node.js](https://nodejs.org/) should be installed before running the setup script.

---

## 📦 Included Packages

| Package | Type | Description |
|---|---|---|
| **pi-codemapper** | Git | Code symbol mapping & static analysis for navigation |
| **pi-minimal-subagent** | Git | Lightweight subagent delegation for parallel tasks |
| **pi-fork** | Git | Fork-based isolated subprocess execution |
| **pi-hooks** | NPM | Lifecycle hooks for the pi agent |
| **pi-rtk-optimizer** | NPM | Response token optimization for cost & latency |
| **pi-observational-memory** | NPM | Observational memory & recall across sessions |
| **pi-mermaid** | NPM | Mermaid diagram generation & rendering |
| **amp-themes** | NPM | UI themes for pi (dark, light, gruvbox, etc.) |
| **pi-powerline-footer** | NPM | Powerline-style footer for the pi TUI |

---

## ⚙️ Configuration

All packages are declared in [`settings.json`](settings.json). Add or remove packages there, then re-run `./scripts/setup-pi.sh` to sync.

```json
{
  "packages": [
    "npm:pi-hooks",
    "npm:pi-rtk-optimizer",
    "git:github.com/elpapi42/pi-codemapper",
    ...
  ]
}
```

Supported sources:
- `npm:<package-name>` — install from the npm registry
- `git:<repo-url>` — clone from a Git repository

---

## 🛠️ Verification

After setup, confirm everything is installed:

```bash
pi list
```

---

## 📁 Project Structure

```
.pi/
├── scripts/
│   └── setup-pi.sh      # One-command bootstrap
├── settings.json        # Package registry
├── agent/               # Custom agent definitions
├── git/                 # Git-cloned packages
└── npm/                 # NPM-installed packages
```

---

## 💡 Tips

- **New machine?** Clone → run setup → done. Your entire pi environment is version-controlled.
- **Update packages?** Pull the latest changes and re-run `./scripts/setup-pi.sh`.
- **Add a new package?** Edit `settings.json` and re-run the script.

---

## 📄 License

This repo is provided as-is. Check individual packages for their respective licenses.

---

*Built with ❤️ for the pi community.*
