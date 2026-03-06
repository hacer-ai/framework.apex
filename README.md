# APEX — Shared Brain for Codex and Claude

APEX is an installable project scaffold for keeping Codex and Claude aligned through a shared `.agents/` memory layer.

This version drops the weak assumption that both tools will auto-discover the same `SKILL.md` files. Instead:

- `AGENTS.md` is the Codex entry point
- `CLAUDE.md` is the Claude entry point
- `.agents/` holds the shared project memory
- `.agents/playbooks/` holds model-agnostic workflows
- `.claude/commands/` contains optional Claude wrappers around the same playbooks

The result is simpler and more defensible: one shared brain, two thin entry points, and no dependency on undocumented cross-tool skill loading.

## Why this version is different

The previous proposal treated documentation as a replacement for code exploration and implied parity around local skill auto-discovery. That is too optimistic.

This repo now reflects a safer operating model:

- Shared docs narrow the search space; they do not replace source inspection.
- Codex compatibility is driven by `AGENTS.md` and shared playbooks.
- Claude compatibility is driven by `CLAUDE.md` plus optional slash-command wrappers.
- Database work always requires both shared-memory review and schema-source verification.

## Repository layout

```text
framework.apex/
├── README.md
├── index.html
├── scripts/
│   └── install-apex.sh
└── templates/
    └── shared-brain/
        ├── AGENTS.md
        ├── CLAUDE.md
        ├── .agents/
        │   ├── CONTEXT.md
        │   ├── MAP.md
        │   ├── SCHEMA.md
        │   ├── TASKS.md
        │   ├── PROGRESS.md
        │   ├── DECISIONS.md
        │   ├── CONTRACTS.md
        │   └── playbooks/
        │       ├── start-session.md
        │       ├── end-session.md
        │       ├── db-change.md
        │       └── plan-feature.md
        └── .claude/
            └── commands/
                ├── apex-start.md
                ├── apex-end.md
                ├── apex-schema.md
                └── apex-plan.md
```

## Install into a project

Run the installer from this repo:

```sh
./scripts/install-apex.sh /path/to/your/project --project-name "My Project"
```

For the current directory:

```sh
./scripts/install-apex.sh .
```

If you want to overwrite existing APEX files:

```sh
./scripts/install-apex.sh . --force
```

The installer copies the scaffold, fills in the project name, and leaves existing files untouched unless `--force` is passed.

## After install

1. Fill in `AGENTS.md` and `CLAUDE.md` with team and project details.
2. Replace placeholders in `.agents/`.
3. Keep `.agents/` updated as part of normal work, especially after:
   - architecture changes
   - new modules
   - API contract changes
   - database changes
   - task priority changes

## How the shared brain works

### `.agents/`

This folder is durable project memory:

- `CONTEXT.md`: stack, services, environment assumptions
- `MAP.md`: high-value map of the codebase
- `SCHEMA.md`: application-facing database view
- `TASKS.md`: current work queue
- `PROGRESS.md`: session log
- `DECISIONS.md`: architectural decisions
- `CONTRACTS.md`: stable interfaces between modules or teams

### `.agents/playbooks/`

These are shared workflows used by both tools:

- `start-session.md`
- `end-session.md`
- `db-change.md`
- `plan-feature.md`

This is the cross-model layer. It is plain markdown, committed with the project, and referenced explicitly by both entry points.

### `.claude/commands/`

These are optional Claude conveniences. They point back to the same playbooks and do not contain separate logic. If Claude command support changes, the shared playbooks remain valid.

## Model compatibility

### Codex

Codex reads `AGENTS.md`. The correct pattern is to instruct Codex there to use `.agents/` and the shared playbooks.

Do not rely on Codex discovering arbitrary local `SKILL.md` files unless your environment explicitly supports that behavior.

### Claude

Claude reads `CLAUDE.md`. If you want slash commands, keep them as thin wrappers around `.agents/playbooks/`.

Do not duplicate the actual workflow logic inside `.claude/commands/`.

## Operating rules

- Shared memory is an accelerator, not a substitute for source validation.
- If the map is stale, fix the map.
- For DB work, check both `SCHEMA.md` and real schema sources.
- Record decisions once in `DECISIONS.md` instead of re-debating them.
- Use `TASKS.md` to coordinate ownership, but verify active code state before editing.

## Open the reference

The repo still ships a static reference page:

```sh
open index.html
```

Or serve it locally:

```sh
python3 -m http.server 8080
```

The HTML is now documentation for the installable scaffold, not the scaffold itself.
