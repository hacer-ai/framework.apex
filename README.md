# APEX — Shared Brain for Claude Code & Codex

APEX is an installable scaffold that gives a software team — humans, Claude Code, and Codex — a single shared memory layer. Every session starts by reading pre-digested context files rather than scanning source code.

- `CLAUDE.md` — Claude Code entry point (auto-read every session)
- `AGENTS.md` — Codex entry point (same purpose, different filename)
- `.agents/` — shared brain: context, map, schema, tasks, progress, decisions, contracts
- `.claude/commands/` — slash commands for Claude Code (`/apex-start`, `/apex-end`, etc.)
- `.claude/skills/` — auto-invoked skills (apex-schema fires automatically on DB work)
- `.agents/skills/` — Codex skills (same content as `.claude/commands/`)

---

## Setup in two steps

### 1. Install the scaffold

Run the installer from this repo into your project:

```sh
./scripts/install-apex.sh /path/to/your/project --project-name "My Project"
```

Or for the current directory:

```sh
./scripts/install-apex.sh .
```

To also get Linear MCP setup instructions printed in your terminal:

```sh
./scripts/install-apex.sh . --linear
```

**`CLAUDE.md` and `AGENTS.md` are never overwritten** — those are yours. Framework files under `.agents/` and `.claude/` can be refreshed with `--force`.

### 2. Initialize the brain

Open Claude Code inside the project and run:

```
/apex-init
```

Claude reads the real codebase and fills `.agents/` automatically:
- Detects stack, services, env vars → writes `CONTEXT.md`
- Maps folders and modules → writes `MAP.md`
- Reads migrations and ORM models → writes `SCHEMA.md` (if DB found)
- Asks about existing tasks before writing `TASKS.md`

For manual control or new projects with no code yet, use the bootstrap prompts in the **Setup** tab of `index.html`.

---

## Daily workflow

```
/apex-start
```

Claude loads the shared brain and shows the task list — **you pick what to work on**:

```
✓ SESSION LOADED
Project: My App · Mode: ACTIVE
Last completed: T-011 — Auth migration
Blocked: none

## Tasks available
In Progress: T-012 — JWT refresh token rotation
Up Next: T-013 — Rate limiting, T-014 — Case detail page

Which task should I work on? (or say "show backlog" / "add task: [description]")
```

Select a task or add a new one. New tasks are created in `TASKS.md` **and** Linear simultaneously.

| When | Run | What happens |
| --- | --- | --- |
| Starting work | `/apex-start` | Loads brain, shows task list, you pick a task |
| Mid-session task switch | `/apex-task` | Shows full task board with T-IDs and descriptions |
| Planning a feature | `/apex-plan [feature]` | Plans across modules before writing code |
| DB work | `/apex-schema [change]` | Schema review guard (also auto-fires on DB phrases) |
| Adding a task | "add task: [desc]" | Creates in TASKS.md + Linear, returns ID |
| Ending work | `/apex-end` | Updates PROGRESS, TASKS, MAP, SCHEMA |

---

## Task management

### Selecting a task
After `/apex-start`, Claude shows In Progress and Up Next tasks. Just say which one (by number or T-ID) to begin. Claude marks it In Progress in TASKS.md and syncs to Linear.

### Adding a task
At any point say: `add task: [description]`. The `apex-linear-add` skill:
1. Assigns the next T-NNN number
2. Creates the Linear issue and gets the ID
3. Appends the task to TASKS.md with `[LIN: ABC-NNN]` inline

### Linear sync
Linear is write-only — TASKS.md is always the read source. Linear only gets called when:
- Bootstrapping all tasks for the first time (`/apex-linear-bootstrap`)
- A task moves to In Progress
- A task is marked Done
- A new task is added

Set up the Linear MCP once per machine:

```sh
claude mcp add-json linear '{"command":"npx","args":["-y","mcp-remote","https://mcp.linear.app/sse"]}'
```

Then authenticate in Claude Code: `/mcp` → follow the OAuth flow.

---

## Commands reference

| Command | Where | What it does |
| --- | --- | --- |
| `/apex-init` | Claude Code | One-time init — fills `.agents/` from the real codebase |
| `/apex-start` | Claude Code / Codex | Load brain, staleness check, show task list, pick a task |
| `/apex-task` | Claude Code | Show task board with T-IDs and descriptions — pick or add |
| `/apex-end` | Claude Code / Codex | Update PROGRESS, TASKS, MAP, SCHEMA, Linear sync |
| `/apex-ship` | Claude Code / Codex | End session + create task branch + commit + optional PR |
| `/apex-review` | Claude Code / Codex | Check changes against CONTRACTS.md and DECISIONS.md |
| `/apex-schema [change]` | Claude Code / Codex | DB change guard — reviews impact before any migration |
| `/apex-plan [feature]` | Claude Code / Codex | Feature planning across modules, no code written yet |
| `/apex-onboard` | Claude Code | New human or agent joining — structured checklist |
| `"add task: [desc]"` | Natural language | Create task in TASKS.md + Linear simultaneously |

### Auto-invocation
`apex-schema` is also installed as a skill in `.claude/skills/apex-schema/` so it fires automatically when you say things like "add a column", "migration", "create table", or "alter table" — without you typing the command.

---

## Shared brain files

| File | Purpose |
| --- | --- |
| `CONTEXT.md` | Stack, services, env vars, constraints |
| `MAP.md` | Codebase map — read this, never scan folders |
| `SCHEMA.md` | All tables, fields, relationships, change log |
| `TASKS.md` | Sprint queue with T-NNN IDs and Linear IDs |
| `PROGRESS.md` | Session log with attribution per entry |
| `DECISIONS.md` | Architecture Decision Records |
| `CONTRACTS.md` | Stable interfaces between modules, with change log |

---

## Scaffold layout

```text
your-project/
├── AGENTS.md                        ← Codex entry point (user-owned)
├── CLAUDE.md                        ← Claude Code entry point (user-owned)
├── .agents/
│   ├── CONTEXT.md
│   ├── MAP.md
│   ├── SCHEMA.md
│   ├── TASKS.md
│   ├── PROGRESS.md
│   ├── DECISIONS.md
│   ├── CONTRACTS.md
│   └── skills/                      ← Codex skills
│       ├── apex-start/SKILL.md
│       ├── apex-end/SKILL.md
│       ├── apex-schema/SKILL.md
│       ├── apex-plan/SKILL.md
│       ├── apex-linear-bootstrap/SKILL.md
│       ├── apex-linear-sync/SKILL.md
│       └── apex-linear-add/SKILL.md
└── .claude/
    ├── commands/                    ← Claude Code slash commands
    │   ├── apex-init.md
    │   ├── apex-start.md
    │   ├── apex-end.md
    │   ├── apex-schema.md
    │   ├── apex-plan.md
    │   └── apex-onboard.md
    └── skills/                      ← Auto-invoked skills
        └── apex-schema/SKILL.md     ← Fires automatically on DB phrases
```

---

## Operating rules

- Read MAP.md first. Never scan source folders speculatively.
- For any DB work, `apex-schema` reads SCHEMA.md before writing anything.
- TASKS.md is the source of truth. Linear is downstream — never read from it.
- Record decisions once in `DECISIONS.md` — stop re-debating them.
- When a contract changes, update `CONTRACTS.md` and notify consumers.

---

## Phase 2 — Planned

These features are designed but not yet built:

| Feature | What it does |
| --- | --- |
| Contractor task filtering | `/apex-task` shows only `[CONTRACTOR: @name]` tasks for that person |
| `apex-standup` | One-paragraph async standup from last 3 PROGRESS.md entries |
| Session locking | Blocks a second agent from picking an already-active task |
| `apex-brief` | Self-contained task brief for contractors — no full codebase access needed |

---

## View the reference page

```sh
open index.html
# or
python3 -m http.server 8080
```
