# APEX — Claude Code Operating Framework

Adaptive Project EXecution. A token-efficient context system for Claude Code that keeps mixed teams aligned across all project phases — enforced via slash commands.

No plugins. No installs. Just markdown files in a folder.

---

## What this is

A reference implementation of the APEX context system, delivered as a single `index.html` file you can open locally or host anywhere. It documents:

- The `.claude/` folder structure Claude Code reads automatically
- Bootstrap prompts for new and existing projects
- Session start/end prompts (and the slash commands that run them)
- DB schema management with `SCHEMA.md`
- Enforcement strategies (CLAUDE.md rules, slash commands, git hooks, PR checklists)
- Starter templates for every `.claude/` file

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

Open the **Setup Prompts** tab in the reference. Pick your path:

- **New project** — paste the bootstrap prompt into Claude Code with your project details
- **Existing project** — run the audit prompt first, confirm the report, then generate the `.claude/` files

Claude will create all context files for you. This takes one session and you never do it again.

---

## A full coding session, step by step

This is what a normal day looks like once APEX is set up on a project.

### 1. Open Claude Code and load the brain

The very first thing, before anything else:

```
/apex-start
```

Claude reads `CLAUDE.md`, `CONTEXT.md`, `MAP.md`, `TASKS.md`, and `PROGRESS.md` silently, then responds with a short summary:

```
---
✓ SESSION LOADED
Project: my-app · Mode: ACTIVE
Last completed: T-011 — Cases table schema + migration (2024-01-15)
Active task: T-012 — JWT refresh token rotation
Blocked: T-019 — waiting on client credentials
---
```

You now know exactly where you left off, what's next, and what's stuck. No scrolling through old messages. No re-reading code to remember context. Claude already knows the codebase map — it won't waste tokens scanning files it doesn't need.

### 2. Work on the active task

Claude picks up `T-012` and starts. You review, approve, redirect. Normal coding session.

**If the task involves database changes**, run this before writing any migration:

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

Claude marks `[DONE]` with today's date in `TASKS.md`, appends a completion note to `PROGRESS.md`, and immediately loads the next task. No manual file editing.

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

Commit the `.claude/` folder. Done.

---

## What to do when you don't know what to work on next

This happens. The task list feels stale, priorities shifted, you're not sure what's actually blocking what.

**Ask Claude directly:**

```
/apex-start

I'm not sure what to pick up. Can you read TASKS.md and PROGRESS.md and give me a priority recommendation based on what's blocked, what's been idle longest, and what's closest to done?
```

Claude will give you a reasoned prioritization from the actual state of your task list — not a guess.

**If the task list itself is out of date**, ask Claude to audit it:

```
Read TASKS.md and PROGRESS.md. Flag any tasks that seem stale (no progress in over a week), any that are marked In Progress but have no recent PROGRESS.md entry, and any that might be unblocked now. Suggest what to cut, what to move up, and what's genuinely next.
```

**If you're waiting on someone else** (a contractor, a client, an external API), mark the task explicitly in `TASKS.md`:

```
T-019 — Datacredito sandbox [BLOCKED: waiting on client credentials since 2024-01-10]
```

Then `/apex-start` will surface it as blocked every session, and you won't accidentally pick it up or forget why it's stalled.

---

## Tracking the timeline and staying on top of progress

`PROGRESS.md` is your session log. Every `/apex-end` appends an entry. Over time it becomes a precise record of what happened, when, and why — useful for retrospectives, for onboarding contractors, and for your own sanity.

To review where things stand at any point:

```
Read PROGRESS.md. Summarize the last 2 weeks of sessions: what was accomplished, what got de-prioritized, and what's taking longer than expected.
```

If you're working with contractors, check their task progress:

```
Read TASKS.md. List all [CONTRACTOR] tasks and their current status. Which ones have no recent PROGRESS.md update?
```

To get a milestone-level view:

```
Read PROGRESS.md and TASKS.md. Given what's done and what's left, how far along is the project overall? What are the remaining open threads?
```

Claude synthesizes the actual written state of both files — no estimating, no hallucinating. It reads what was committed.

---

## What happens if you forget to run `/apex-end`

It happens. You finish a task, close your laptop, and the context files never got updated. Here's the damage and how to fix it.

**What breaks:**
- `PROGRESS.md` has no entry for that session — the work is invisible in the log
- `TASKS.md` still shows the task as In Progress instead of Done
- If you made DB changes, `SCHEMA.md` is stale — the next session's schema check will be based on wrong data
- The next developer (or you, tomorrow) opens the project and `/apex-start` surfaces the wrong active task

**How to recover:**

At the start of the next session, before or after `/apex-start`, run:

```
I forgot to run /apex-end last session. Here's what I actually did: [describe what you completed, any DB changes, any decisions made]. Please update PROGRESS.md, TASKS.md, MAP.md, SCHEMA.md, and DECISIONS.md as if /apex-end had been run at the end of that session. Use yesterday's date for the PROGRESS.md entry.
```

Claude will reconstruct the session end from your description and update all files correctly. Then commit the `.claude/` folder.

**If you don't remember what you did:**

```
Read PROGRESS.md and TASKS.md. Look at git log for the last 48 hours and tell me what changed, then update the context files accordingly.
```

Claude cross-references the actual git history against the context files and patches the gaps.

**Prevention:** The simplest habit is to type `/apex-end` before you commit your code. The two actions belong together — commit the work, commit the brain update. If you use the git commit message Claude outputs from `/apex-end`, it becomes a natural forcing function.

---

## The `.claude/` folder structure

```
your-project/
├── CLAUDE.md                    # Auto-read by Claude Code on every session
└── .claude/
    ├── CONTEXT.md               # Stack, services, env vars
    ├── MAP.md                   # Every module described — replaces file scanning
    ├── SCHEMA.md                # All tables, fields, relationships, change log
    ├── TASKS.md                 # Numbered sprint queue with [LEAD]/[CONTRACTOR] tags
    ├── PROGRESS.md              # Milestone timeline + session log
    ├── DECISIONS.md             # Architecture decisions — never re-debate
    ├── CONTRACTS.md             # API endpoints, shared interfaces
    └── commands/
        ├── apex-start.md        # /apex-start
        ├── apex-end.md          # /apex-end
        ├── apex-schema.md       # /apex-schema
        └── apex-plan.md         # /apex-plan
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
