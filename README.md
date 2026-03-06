# APEX — Shared Brain for Codex and Claude

APEX is an installable scaffold that gives a software team — humans and AI agents together — a single shared memory layer. Every session, every tool, and every contributor reads from and writes to the same `.agents/` folder.

- `AGENTS.md` — Codex entry point
- `CLAUDE.md` — Claude entry point
- `.agents/` — shared project memory (context, map, schema, tasks, decisions, contracts)
- `.agents/playbooks/` — model-agnostic workflows
- `.claude/commands/` — optional Claude slash-command wrappers

One shared brain. Two thin entry points. No fake cross-tool parity.

---

## How to use APEX in three steps

### 1. Install the scaffold

Run the installer from this repo into your project:

```sh
./scripts/install-apex.sh /path/to/your/project --project-name "My Project"
```

Or for the current directory:

```sh
./scripts/install-apex.sh .
```

The installer creates all scaffold files. **It never overwrites `CLAUDE.md` or `AGENTS.md`** — those are yours. Framework files under `.agents/` and `.claude/commands/` can be refreshed with `--force`.

### 2. Initialize the shared brain

Open Claude Code inside the project and run:

```
/apex-init
```

Claude reads the real codebase and fills in `.agents/` automatically:
- Detects stack, services, and environment variables → writes `CONTEXT.md`
- Maps folders and key modules → writes `MAP.md`
- Reads migrations and ORM models → writes `SCHEMA.md` (if DB found)
- Asks whether you have existing tasks to import → writes `TASKS.md`

After init, review the generated files and correct anything Claude could not infer.

### 3. Start every work session

```
/apex-start
```

Claude loads the shared brain and returns a compact handoff:

```
SESSION LOADED
Project: My App · Mode: ACTIVE
Last completed: T-003 — Auth migration
Active task: T-004 — Payment webhook
Blocked: none
Risks: none
```

---

## Daily workflow

| When | Run | What happens |
| --- | --- | --- |
| Starting work | `/apex-start` | Loads shared brain, surfaces active task |
| Planning a feature | `/apex-plan` | Plans across modules before writing code |
| DB work | `/apex-schema` | Forces schema review before any migration |
| New contributor | `/apex-onboard` | Structured onboarding checklist |
| Ending work | `/apex-end` | Updates PROGRESS, TASKS, MAP, SCHEMA |

---

## Team conventions

### Active-work signal
When taking a task, add `🔒 ACTIVO` to the line in `TASKS.md`:

```md
- [ ] T-004 — Payment webhook `[Ana]` 🔒 ACTIVO: Ana · 2026-03-06
```

Remove it when done or when committing. Prevents two agents or contributors from taking the same task simultaneously.

### Session attribution
Every entry in `PROGRESS.md` records who did the work:

```md
### 2026-03-06 · Ana · work
### 2026-03-06 · Claude · planning
### 2026-03-06 · Codex · work
```

### Staleness tracking
`MAP.md` and `SCHEMA.md` include a "Última verificación" block with commit hash, date, and author. If the map contradicts the source, fix the map.

---

## Shared brain files

| File | Purpose |
| --- | --- |
| `CONTEXT.md` | Stack, services, environment variables, constraints |
| `MAP.md` | Codebase map with last-verified commit |
| `SCHEMA.md` | Application-facing DB view with last-verified commit |
| `TASKS.md` | Work queue with ownership and active-work signal |
| `PROGRESS.md` | Session log with attribution per entry |
| `DECISIONS.md` | Architectural decisions (ADR format) |
| `CONTRACTS.md` | Stable interfaces between modules or teams, with change log |

---

## Playbooks

Playbooks are model-agnostic markdown workflows in `.agents/playbooks/`. Both Codex and Claude follow the same playbooks.

| Playbook | When to use |
| --- | --- |
| `init.md` | Once, after install — fills `.agents/` from the real codebase |
| `start-session.md` | Beginning of every work session |
| `end-session.md` | End of every work session |
| `plan-feature.md` | Before implementing anything that spans multiple modules |
| `db-change.md` | Any migration, schema edit, or DB-dependent feature |
| `onboard.md` | When a new human or agent joins the project |

`.claude/commands/` are thin wrappers that open the corresponding playbook. No logic lives in the commands themselves.

---

## Scaffold layout

```text
your-project/
├── AGENTS.md                        ← Codex entry point (user-owned)
├── CLAUDE.md                        ← Claude entry point (user-owned)
├── .agents/
│   ├── CONTEXT.md
│   ├── MAP.md
│   ├── SCHEMA.md
│   ├── TASKS.md
│   ├── PROGRESS.md
│   ├── DECISIONS.md
│   ├── CONTRACTS.md
│   └── playbooks/
│       ├── init.md
│       ├── start-session.md
│       ├── end-session.md
│       ├── plan-feature.md
│       ├── db-change.md
│       └── onboard.md
└── .claude/
    └── commands/
        ├── apex-init.md
        ├── apex-start.md
        ├── apex-end.md
        ├── apex-plan.md
        ├── apex-schema.md
        └── apex-onboard.md
```

---

## Operating rules

- Shared memory is an accelerator, not a substitute for reading the code that is about to change.
- If the map is stale, fix the map before using it.
- For DB work, always check both `SCHEMA.md` and the real migration/ORM source.
- Record decisions once in `DECISIONS.md` — stop re-debating them.
- When a contract changes, update `CONTRACTS.md` and notify all listed consumers.
- If `🔒 ACTIVO` is on a task, coordinate before taking it.

---

## View the reference page

```sh
open index.html
# or
python3 -m http.server 8080
```
