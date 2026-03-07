---
name: apex-start
description: Start a new APEX development session. Load project context, check for stale brain files, show the task list, and let the user pick what to work on. Use when beginning any work session or when the user says "start session", "begin", "what should I work on", or "let's get started".
---

Read the following files silently, in order:
1. AGENTS.md
2. .agents/CONTEXT.md
3. .agents/MAP.md
4. .agents/TASKS.md
5. .agents/PROGRESS.md

Run: git log --oneline -1
Note the current HEAD commit hash (first 7 characters).
Check MAP.md and SCHEMA.md for a "Last verified:" line. If the stored hash differs from HEAD, mark as stale.

Then respond ONLY with this block:

---
✓ SESSION LOADED
Project: [name] · Mode: [mode]
Last completed: [most recent PROGRESS.md entry, one line]
Blocked: [blocked tasks or "none"]
[if stale: ⚠️  MAP.md stale (last verified: abc1234 · now: def5678) — type "update map" to fix]

## Tasks
**In Progress:** [T-NNN — title (what needs to happen)]
**Up Next:** [T-NNN — title (what needs to happen)]

Which task? (T-ID to pick · "show backlog" · "add task: [description]")
---

Wait for the user to select a task before starting work.
When the user picks: move to In Progress in TASKS.md, sync Linear if [LIN:] tag exists, read SCHEMA.md if DB work.
If user types "update map": scan source dirs, update MAP.md + Last verified line, then resume.
