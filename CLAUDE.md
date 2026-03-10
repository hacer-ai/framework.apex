# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`framework.apex` is the source repo for the **APEX shared-brain scaffold** — an installable template that keeps Claude Code and OpenAI Codex aligned on the same project memory. It is not a web app or a library; it ships a shell installer and a set of markdown templates.

Target users: solo devs and small teams (2-5 people) using AI coding tools.

## Installing the scaffold into a project

```sh
# Install into a target directory
./scripts/install-apex.sh /path/to/project --project-name "My Project"

# Install into the current directory
./scripts/install-apex.sh .

# Refresh framework files (commands + skills) without touching project-owned files
./scripts/install-apex.sh . --force
```

## Key design rules

- **Project-owned files** are created once and never overwritten, even with `--force`:
  - `CLAUDE.md`, `AGENTS.md` (entry points)
  - `.agents/CONTEXT.md`, `.agents/MAP.md`, `.agents/SCHEMA.md`, `.agents/TASKS.md`, `.agents/PROGRESS.md`, `.agents/DECISIONS.md`, `.agents/CONTRACTS.md` (brain files)
- **Framework files** (commands in `.claude/commands/`, skills in `.claude/skills/` and `.agents/skills/`) are safe to overwrite with `--force`.
- `templates/shared-brain/` is the single source of truth for all scaffold content. Every file uses `__PROJECT_NAME__` as the placeholder, which the installer replaces via `sed`.
- `.agents/skills/` are Codex-facing skills. `.claude/commands/` are Claude Code slash commands. `.claude/skills/` are Claude Code auto-invocation skills. The brain files in `.agents/*.md` are shared and model-agnostic.
- Shared memory (`.agents/`) narrows the search space; it does not replace reading the actual source code before making edits.

## Architecture

```
framework.apex/
├── scripts/install-apex.sh   # Installer: copies templates, substitutes __PROJECT_NAME__
├── templates/shared-brain/   # All scaffold files (the source of truth)
│   ├── AGENTS.md             # Codex entry point template
│   ├── CLAUDE.md             # Claude Code entry point template
│   ├── .agents/              # Shared brain templates (project-owned after install)
│   │   └── skills/           # Codex skill templates (framework-managed)
│   ├── .claude/commands/     # Claude Code slash commands (framework-managed)
│   └── .claude/skills/       # Claude Code auto-invocation skills (framework-managed)
└── index.html                # Interactive reference page (documentation)
```

## File categories in the installer

| Category | Array in installer | `--force` behavior | Examples |
|---|---|---|---|
| Project-owned | `USER_FILES` | Never overwritten | `CLAUDE.md`, `.agents/MAP.md`, `.agents/TASKS.md` |
| Framework | `FILES` | Overwritten | `.claude/commands/apex-start.md`, `.agents/skills/apex-start/SKILL.md` |

## Modifying templates

When adding a new template file:
1. Add the file under `templates/shared-brain/` using `__PROJECT_NAME__` for the project name placeholder.
2. Add it to the appropriate array in `scripts/install-apex.sh`:
   - `USER_FILES` if it contains project-specific data the user maintains (brain files, entry points).
   - `FILES` if it's a workflow/command file that APEX controls and can safely refresh.
3. Update `index.html` if the scaffold layout changes.

## Claude Code vs Codex — where files go

| Purpose | Claude Code path | Codex path |
|---|---|---|
| Entry point | `CLAUDE.md` (auto-read) | `AGENTS.md` (auto-read) |
| Slash commands | `.claude/commands/*.md` | N/A |
| Auto-invoked skills | `.claude/skills/name/SKILL.md` | `.agents/skills/name/SKILL.md` |
| Manual skills | `.claude/commands/*.md` | `.agents/skills/name/SKILL.md` |
| Shared brain | `.agents/*.md` | `.agents/*.md` |

Claude Code does NOT read `.agents/skills/`. Codex does NOT read `.claude/`.

## Future: multi-tool support (planned)

The `.agents/` brain is model-agnostic by design. Future phases will add thin entry-point adapters for:
- **Cursor** → `.cursor/rules/`
- **Windsurf** → `.windsurfrules`
- **Aider** → `.aider.conf.yml`
- **Copilot Workspace** → `.github/copilot-instructions.md`

Same shared brain, more front doors. No code for these yet — just the architecture direction.
