# APEX v3 — Claude Code & Codex Operating Framework

Adaptive Project EXecution. A token-efficient context system that keeps mixed teams aligned across all project phases — works with **Claude Code and OpenAI Codex from the same files**.

No plugins. No installs. Just markdown files in a folder.

---

## What this is

A reference implementation of the APEX context system, delivered as a single `index.html` file you can open locally or host anywhere. It documents:

- The `.agents/` shared brain structure — read by both Claude Code and Codex
- `CLAUDE.md` (Claude Code entry point) and `AGENTS.md` (Codex entry point)
- Skills that auto-invoke the right workflow — zero token cost until needed
- DB schema management with `SCHEMA.md` and the `apex-schema` skill
- Bootstrap prompts for new and existing projects
- Session start/end skills and how to run them
- Linear MCP integration for both Claude Code and Codex
- Starter templates for every `.agents/` file

---

## What's new in v3

- **Skills replace slash commands** — moved from `.claude/commands/` to `.agents/skills/` as `SKILL.md` files with YAML frontmatter (merged in Claude Code v2.1.3)
- **Auto-invocation** — Claude loads skills only when the task matches. `apex-schema` fires automatically on any DB work; you don't need to type `/apex-schema`
- **Cross-model** — both Claude Code and Codex follow the open Agent Skills standard. Your `.agents/skills/` folder works in both tools
- **Shared brain** — one `.agents/` folder, two thin entry-point files (`CLAUDE.md` for Claude Code, `AGENTS.md` for Codex). No duplication
- **Linear integration** — MCP setup for both tools, Linear IDs stored inline in `TASKS.md`

---

## First-time setup

### 1. Clone the repo

```sh
git clone https://github.com/hacer-ai/framework.apex.git
cd framework.apex
```

### 2. Open the reference

```sh
open index.html
```

Or serve it locally:

```sh
npx serve .
# or
python3 -m http.server 8080
```

No build step. No dependencies. It's a single HTML file.

### 3. Apply APEX to your own project

Open the **Setup** tab in the reference. Pick your path:

- **New project** — paste the bootstrap prompt into Claude Code or Codex with your project details
- **Existing project** — run the audit prompt first, confirm the report, then generate the `.agents/` files

Claude will create all context files for you. This takes one session and you never do it again.

---

## A full coding session, step by step

This is what a normal day looks like once APEX is set up on a project.

### 1. Open Claude Code (or Codex) and load the brain

The very first thing, before anything else:

```
/apex-start
```

Claude reads `.agents/CONTEXT.md`, `.agents/MAP.md`, `.agents/TASKS.md`, and `.agents/PROGRESS.md` silently, then responds with a short summary:

```
---
SESSION LOADED
Project: my-app · Mode: ACTIVE
Last completed: T-011 — Cases table schema + migration (2024-01-15)
Active task: T-012 — JWT refresh token rotation
Blocked: T-019 — waiting on client credentials
---
```

You now know exactly where you left off, what's next, and what's stuck.

### 2. Work on the active task

Claude picks up `T-012` and starts. You review, approve, redirect. Normal coding session.

**If the task involves database changes**, the `apex-schema` skill fires automatically — no command needed. Or run it manually:

```
/apex-schema add a "refresh_token" column to the sessions table
```

Claude reads `SCHEMA.md`, checks for constraint conflicts, FK impacts, downstream module effects, and whether the change is destructive. It proposes the migration and waits for your approval. Then it writes the migration file and updates `SCHEMA.md`.

**If you need to plan a new feature** before writing code:

```
/apex-plan user-facing audit log with filters and export
```

Claude produces an impact analysis, required schema changes, new files to add to `MAP.md`, contract changes, and an ordered task breakdown — all without touching the codebase. You approve the plan, then the tasks go into `TASKS.md` and work begins.

### 3. Switching tasks mid-session

Finished a task early, or pivoting? Tell Claude:

```
Mark T-012 done, move to T-013
```

Claude marks `[DONE]` with today's date in `TASKS.md`, appends a completion note to `PROGRESS.md`, and immediately loads the next task.

### 4. End the session

Before you close Claude Code:

```
/apex-end
```

Claude updates all context files:
- `PROGRESS.md` — appends today's entry: what was completed, what carries forward, any decisions or surprises
- `TASKS.md` — marks completed tasks `[DONE]`, adds any new tasks discovered during the session, re-prioritizes if needed
- `MAP.md` — registers any new files or modules created
- `SCHEMA.md` — if DB work happened, updates affected tables and appends to the change log
- `DECISIONS.md` — records any architectural decisions made

Then outputs a ready-to-use commit message:

```
chore(apex): 2024-01-16 — JWT refresh token rotation complete
```

Commit the `.agents/` folder. Done.

---

## Claude Code vs Codex — when to use which

Both tools read the same `.agents/` brain. Context is never lost between them.

**Use Claude Code for** interactive sessions, complex multi-step tasks, architecture decisions, code review, and contractor onboarding. Skill auto-invocation and `CLAUDE.md` rules make it the better choice for open-ended work requiring judgment.

**Use Codex for** batch tasks, parallel feature branches, well-scoped automated work. Codex's cloud execution and multi-agent parallelism makes it strong for running several tasks simultaneously.

**The handoff pattern:** Plan in Claude Code (interactive, architectural) → run bulk tasks in Codex (parallel, cloud) → review and merge in Claude Code. Run `/apex-end` in Claude Code before handing off to Codex so `TASKS.md` is current.

---

## The `.agents/` folder structure

```
your-project/
├── CLAUDE.md                    # Claude Code entry point — auto-read every session
├── AGENTS.md                    # Codex entry point — same content, different filename
└── .agents/
    ├── CONTEXT.md               # Stack, services, env vars
    ├── MAP.md                   # Every module described — replaces file scanning
    ├── SCHEMA.md                # All tables, fields, relationships, change log
    ├── TASKS.md                 # Numbered sprint queue with [LEAD]/[CONTRACTOR] tags
    ├── PROGRESS.md              # Milestone timeline + session log
    ├── DECISIONS.md             # Architecture decisions — never re-debate
    ├── CONTRACTS.md             # API endpoints, shared interfaces
    └── skills/
        ├── apex-start/
        │   └── SKILL.md         # /apex-start — loads context, picks next task
        ├── apex-end/
        │   └── SKILL.md         # /apex-end — commits the brain after each session
        ├── apex-schema/
        │   └── SKILL.md         # /apex-schema — DB change guard, auto-invoked
        └── apex-plan/
            └── SKILL.md         # /apex-plan — feature planning before any code
```

Skills use YAML frontmatter (`name`, `description`) and follow the open Agent Skills standard — the same `SKILL.md` file works in both Claude Code and Codex.

---

## What to do when you don't know what to work on next

**Ask Claude directly:**

```
/apex-start

I'm not sure what to pick up. Can you read TASKS.md and PROGRESS.md and give me a priority recommendation based on what's blocked, what's been idle longest, and what's closest to done?
```

**If the task list itself is out of date**, ask Claude to audit it:

```
Read TASKS.md and PROGRESS.md. Flag any tasks that seem stale (no progress in over a week), any that are marked In Progress but have no recent PROGRESS.md entry, and any that might be unblocked now. Suggest what to cut, what to move up, and what's genuinely next.
```

**If you're waiting on someone else**, mark the task explicitly in `TASKS.md`:

```
T-019 — Datacredito sandbox [BLOCKED: waiting on client credentials since 2024-01-10]
```

Then `/apex-start` will surface it as blocked every session, and you won't accidentally pick it up or forget why it's stalled.

---

## Tracking the timeline and staying on top of progress

`PROGRESS.md` is your session log. Every `/apex-end` appends an entry. Over time it becomes a precise record of what happened, when, and why.

To review where things stand at any point:

```
Read PROGRESS.md. Summarize the last 2 weeks of sessions: what was accomplished, what got de-prioritized, and what's taking longer than expected.
```

To get a milestone-level view:

```
Read PROGRESS.md and TASKS.md. Given what's done and what's left, how far along is the project overall? What are the remaining open threads?
```

---

## What happens if you forget to run `/apex-end`

At the start of the next session, before or after `/apex-start`, run:

```
I forgot to run /apex-end last session. Here's what I actually did: [describe what you completed, any DB changes, any decisions made]. Please update PROGRESS.md, TASKS.md, MAP.md, SCHEMA.md, and DECISIONS.md as if /apex-end had been run at the end of that session. Use yesterday's date for the PROGRESS.md entry.
```

If you don't remember what you did:

```
Read PROGRESS.md and TASKS.md. Look at git log for the last 48 hours and tell me what changed, then update the context files accordingly.
```

---

## Contributing

The entire framework lives in `index.html`. Edit it directly — styles, prompts, and templates are all inline. Open a PR with your changes.

---

<p align="right">
  <a href="https://hacer.ai">
    <img src="https://hacer.ai/dist/assets/Logo_black.svg" alt="hacer.ai" height="22">
  </a>
</p>
