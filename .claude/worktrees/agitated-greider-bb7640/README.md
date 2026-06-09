# APEX — Shared brain for AI coding teams

> **One file-based memory layer that keeps your team and your AI agents on the same page — fewer tokens per session, fewer "wait, what was I doing?" moments, one source of truth across Claude Code, Codex, and Linear.**

🇪🇸 [Leer en español](README.es.md)

---

## Why APEX exists

Every AI coding session starts the same way: the agent re-reads files it already knows, re-asks questions it already answered, and re-decides architecture you already settled. Multiply that across two or three agents and a small team and the cost — in tokens, in attention, in context drift — gets ugly fast.

APEX gives the project **one shared brain on disk**: a small set of pre-digested markdown files (`.agents/`) that every agent reads instead of scanning the source tree. Two outcomes:

1. **Lower token consumption.** A 2 KB `MAP.md` replaces hundreds of file reads. A 1 KB `DECISIONS.md` ends arguments before they restart. Most sessions load < 5 KB of context before doing real work.
2. **Synchronized teams.** Humans, Claude Code, and Codex all read and write the same brain. Linear is the team-facing layer — APEX keeps `TASKS.md` and Linear in sync so non-engineers see real status without touching the repo.

APEX is **not** an orchestration platform like OpenAI's Symphony — it's the layer underneath. If Symphony is "manage work, not agents," APEX is "give the agents one brain to manage from." Solo devs and small teams (2–5 people) can run APEX with zero infrastructure; bigger teams can keep APEX and graduate to Symphony on top.

---

## Setup in two steps

### 1. Install the scaffold

```sh
./scripts/install-apex.sh /path/to/your/project --project-name "My Project"
```

Or for the current directory:

```sh
./scripts/install-apex.sh .
```

Add Linear MCP setup instructions to the install output:

```sh
./scripts/install-apex.sh . --linear
```

**`CLAUDE.md`, `AGENTS.md`, and the brain files under `.agents/` are never overwritten** — those become yours after first install. Framework files (slash commands, skills) refresh with `--force`.

### 2. Initialize the brain

Open Claude Code inside the project and run:

```
/apex-init
```

Claude reads the real codebase and fills `.agents/` automatically:
- Detects stack, services, env vars → writes `CONTEXT.md`
- Maps folders and modules → writes `MAP.md`
- Reads migrations and ORM models → writes `SCHEMA.md` (if a DB is present)
- Asks about existing tasks before writing `TASKS.md`

For projects with no code yet, use the bootstrap prompts in the **Setup** tab of `index.html`.

---

## Daily workflow

```
/apex-start
```

Loads the active task list and shows what needs to happen:

```
✓ SESSION LOADED
Project: My App · Mode: ACTIVE · Linear: source
Last completed: T-011 — Auth migration
Blocked: none

In Progress:    T-012 — JWT refresh token rotation
Human Review:   T-009 — Rate limiting (PR #57)
Up Next (Todo): T-013 — Idempotency keys, T-014 — Case detail page

Which task? (T-ID · "show backlog" · "add task: [description]")
```

Pick a task or add one. Brain files (`MAP.md`, `CONTEXT.md`, `DECISIONS.md`) are loaded **on demand** — only when the selected task actually needs them. That's where most of the token savings come from.

```
/apex-end
```

Updates `TASKS.md`, `PROGRESS.md`, `MAP.md`, `SCHEMA.md`, and `DECISIONS.md`. Pushes any state transitions to Linear. Refuses to mark a task Done without a `[PR: #N]` or `[@<short-sha>]` proof tag.

| When | Run | What happens |
| --- | --- | --- |
| First setup | `/apex-init` | Fills `.agents/` from the real codebase |
| Starting work | `/apex-start` | Loads task list (lazy), pick a task |
| DB work | (automatic) | `apex-schema` fires on DB phrases |
| Adding a task | "add task: [desc]" | Creates in TASKS.md (and Linear) |
| Ending work | `/apex-end` | Updates brain files, gates Done on proof |
| Sync with team | `/apex-sync` | Pull from Linear + push state changes |
| Weekly cleanup | `/apex-tidy` | Archive old Done, compress logs (cheap on Haiku) |

---

## Task model

`TASKS.md` is the **buffer** between Linear and the active session. It uses a simple state machine:

```
Todo  →  In Progress  →  Human Review  →  Done
                    ↑           │
                    └─── Rework ┘
```

Plus parking lots: **Backlog** (not scheduled), **Blocked** (external dependency).

A task only enters Done with proof: `[PR: #N]` (pull request) or `[@<short-sha>]` (commit). This mirrors the proof-of-work principle from Symphony, but at file scale — no infrastructure required.

---

## Linear integration

Linear is **optional but supported as a first-class layer**. Set `LINEAR_MODE` in `.agents/CONTEXT.md`:

| Mode | Behavior | When to use |
| --- | --- | --- |
| `source` | Linear is the team's source of truth. `/apex-start` runs `/apex-sync` first. | Teams of 2+, especially with non-engineers creating tickets |
| `mirror` | TASKS.md is local-first; state pushed to Linear on transitions. (Default.) | Solo work that wants a durable archive |
| `off` | Linear unused. All Linear skills no-op. | Personal projects |

`/apex-sync` is bidirectional and idempotent: it pulls Linear issues with the `apex` label or assigned to you into `TASKS.md`, then pushes any state changes you've made locally back to Linear. Run it at the start of a shared session, or whenever a teammate adds a ticket from the Linear UI.

Set up the Linear MCP once per machine:

```sh
claude mcp add-json linear '{"command":"npx","args":["-y","mcp-remote","https://mcp.linear.app/sse"]}'
```

Then authenticate in Claude Code: `/mcp` → follow the OAuth flow.

---

## Cheap housekeeping with Haiku

`/apex-tidy` is a pure janitorial pass — archive Done tasks older than 14 days, compress old `PROGRESS.md` sessions, fix `T-NNN` / `ADR-NNN` collisions, normalize formatting. It writes no new content and makes no decisions. That makes it perfect for a cheap, fast model.

Run it headless on Haiku to keep cost minimal:

```sh
claude -p --model claude-haiku-4-5-20251001 "/apex-tidy"
```

Drop that into a cron (Sunday nights) or a git pre-push hook and your brain stays tidy without ever burning Opus tokens on cleanup.

---

## Worktrees for parallel work

Claude Code natively supports git worktrees. APEX plays well with them: each worktree gets its own `.agents/` (because they share the working tree), so two agents working different branches don't fight over `TASKS.md`. Tag the active task with `🔒 ACTIVO: <name> · YYYY-MM-DD` so the other side sees who has what.

For the Symphony-style "isolated per-issue workspace" model, a worktree per Linear issue is essentially free and aligns with the rest of the workflow.

---

## Commands reference

| Command | Where | What it does |
| --- | --- | --- |
| `/apex-init` | Claude Code | One-time init — fills `.agents/` from the codebase |
| `/apex-start` | Claude Code / Codex | Load task list (lazy), pick a task; runs `/apex-sync` first if `LINEAR_MODE=source` |
| `/apex-end` | Claude Code / Codex | Update brain files; gate Done on `[PR: #N]` or `[@hash]` |
| `/apex-sync` | Claude Code / Codex | Bidirectional Linear reconcile (pull + push) |
| `/apex-tidy` | Claude Code / Codex | Archive Done > 14 days, compress logs, fix collisions (run on Haiku) |
| `apex-schema` | Auto-invoked | DB change guard — fires on migration/schema phrases |
| `apex-linear-bootstrap` | Manual | First-time push of all tasks to Linear |
| `apex-linear-add` | Auto-invoked on "add task" | Create task in TASKS.md (and Linear) |
| `apex-linear-sync` | Called by other skills | Push a single task's state change to Linear |

### Auto-invocation
`apex-schema` is installed as a skill in `.claude/skills/apex-schema/` so it fires automatically when you say things like "add a column", "migration", "create table", or "alter table". You can also call it directly as `/apex-schema`.

### Context tip
Run `/compact` mid-session if the context window is getting heavy. The built-in compactor summarizes conversation history without losing working state.

---

## Shared brain files

| File | Purpose | Owned by |
| --- | --- | --- |
| `CONTEXT.md` | Stack, services, env vars, `LINEAR_MODE`, constraints | You |
| `MAP.md` | Codebase map — read this, never scan folders | You |
| `SCHEMA.md` | All tables, fields, relationships, change log | You |
| `TASKS.md` | Sprint queue with T-NNN IDs and Linear IDs | You |
| `PROGRESS.md` | Session log with attribution per entry | You |
| `DECISIONS.md` | Architecture Decision Records | You |
| `CONTRACTS.md` | Stable interfaces between modules (optional, > 10 endpoints) | You |
| `archive/` | Auto-populated by `/apex-tidy` | Framework |

---

## Scaffold layout

```text
your-project/
├── AGENTS.md                        ← Codex entry point
├── CLAUDE.md                        ← Claude Code entry point
├── .agents/
│   ├── CONTEXT.md
│   ├── MAP.md
│   ├── SCHEMA.md
│   ├── TASKS.md
│   ├── PROGRESS.md
│   ├── DECISIONS.md
│   ├── CONTRACTS.md                 (optional)
│   ├── archive/                     (auto-created by /apex-tidy)
│   └── skills/                      ← Codex skills
│       ├── apex-start/
│       ├── apex-end/
│       ├── apex-sync/
│       ├── apex-tidy/
│       ├── apex-schema/
│       ├── apex-linear-bootstrap/
│       ├── apex-linear-sync/
│       └── apex-linear-add/
└── .claude/
    ├── commands/                    ← Claude Code slash commands
    │   ├── apex-init.md
    │   ├── apex-start.md
    │   ├── apex-end.md
    │   ├── apex-sync.md
    │   └── apex-tidy.md
    └── skills/
        └── apex-schema/             ← Auto-fires on DB phrases
```

---

## Operating rules

- Run `/apex-start` to begin. Do not bulk-read all brain files upfront.
- For any DB work, `apex-schema` reads `SCHEMA.md` before writing anything.
- A task does not enter Done without `[PR: #N]` or `[@<short-sha>]`.
- Record decisions once in `DECISIONS.md` — stop re-debating them.
- When a contract changes, update `CONTRACTS.md` and notify consumers.
- Run `/apex-tidy` weekly (or on a hook) — keep the brain small.

---

## How APEX compares

| | APEX | OpenAI Symphony | Plain `CLAUDE.md` |
| --- | --- | --- | --- |
| Infrastructure | None — markdown + bash | Elixir/OTP service + dashboard | None |
| Source of truth | TASKS.md or Linear (configurable) | Linear | The repo |
| Isolation | Worktrees (optional) | Per-issue workspaces (built-in) | None |
| Proof of work | PR / commit-hash gate in `/apex-end` | PR + CI + addressed comments + workpad | None |
| Multi-agent | Sequential, file-locked | Parallel, supervised by service | N/A |
| Best for | Solo / small teams / on-ramp | Mid-large teams running fleets of agents | One-off projects |

APEX and Symphony aren't competitors — APEX is the **harness layer** Symphony assumes you have. If you outgrow APEX, the brain files port directly: `TASKS.md` states already match Symphony's state machine.

---

## View the reference page

```sh
open index.html
# or
python3 -m http.server 8080
```

---

## License

MIT.
