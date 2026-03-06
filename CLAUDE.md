# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`framework.apex` is the source repo for the **APEX shared-brain scaffold** — an installable template that keeps Codex and Claude aligned on the same project memory. It is not a web app or a library; it ships a shell installer and a set of markdown templates.

## Installing the scaffold into a project

```sh
# Install into a target directory
./scripts/install-apex.sh /path/to/project --project-name "My Project"

# Install into the current directory
./scripts/install-apex.sh .

# Overwrite existing framework files (never overwrites CLAUDE.md or AGENTS.md)
./scripts/install-apex.sh . --force
```

## Key design rules

- `CLAUDE.md` and `AGENTS.md` are **user-owned** files — the installer never overwrites them, even with `--force`. Only framework files under `.agents/` and `.claude/commands/` are overwritten by `--force`.
- `templates/shared-brain/` is the single source of truth for all scaffold content. Every file there uses `__PROJECT_NAME__` as the placeholder, which the installer replaces via `sed`.
- `.agents/playbooks/` are model-agnostic. `.claude/commands/` are thin wrappers that point to those playbooks — no workflow logic lives in the commands themselves.
- Shared memory (`.agents/`) narrows the search space; it does not replace reading the actual source code before making edits.

## Architecture

```
framework.apex/
├── scripts/install-apex.sh   # Installer: copies templates, substitutes __PROJECT_NAME__
├── templates/shared-brain/   # All scaffold files (the source of truth)
│   ├── AGENTS.md             # Codex entry point template
│   ├── CLAUDE.md             # Claude entry point template
│   ├── .agents/              # Shared project memory templates
│   │   └── playbooks/        # Model-agnostic workflow templates (init, start, end, db, plan, onboard)
│   └── .claude/commands/     # Claude slash-command wrappers (point to playbooks)
└── index.html                # Static reference page (documentation only)
```

The installer has two categories of files:
- **User-owned** (`AGENTS.md`, `CLAUDE.md`): created on first install, never overwritten.
- **Framework files** (everything else): skipped by default, overwritten with `--force`.

## Modifying templates

When adding a new template file:
1. Add the file under `templates/shared-brain/` using `__PROJECT_NAME__` for the project name placeholder.
2. Add it to the appropriate array in `scripts/install-apex.sh` — `USER_FILES` if user-owned, `FILES` if a framework file.
3. Update `README.md` and `index.html` if the scaffold layout changes.
