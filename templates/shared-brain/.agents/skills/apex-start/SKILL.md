---
name: apex-start
description: Begin a work session. Load tasks and session status. Use when starting work or saying "let's begin", "what should I work on", "start session".
---

Read these files silently:
1. `.agents/TASKS.md` — In Progress and Up Next sections only (stop before Backlog)
2. `.agents/PROGRESS.md` — last entry only

Check MAP.md for a "Last verified:" line. If the stored commit hash is missing or stale, mark as stale.

Health checks (silent, report warnings in output):
- "In Progress" has items marked [x] or DONE → warn stale tasks stuck in wrong section
- TASKS.md > 400 lines → warn bloat

Respond ONLY with this block:

---
✓ SESSION LOADED
Project: [name] · Mode: [mode]
Last completed: [last PROGRESS.md entry, one line]
Blocked: [blocked tasks or "none"]
[if stale: ⚠ MAP.md stale — say "update map" to fix]
[if health warnings: one line each]

**In Progress:** T-NNN — title
**Up Next:** T-NNN — title

Which task? (T-ID · "show backlog" · "add task: [description]")
---

Wait for task selection before reading any other files or writing code.

On task selection:
- Move task to In Progress in TASKS.md if not already there
- If [LIN: ABC-NNN] tag exists, sync Linear status
- Read `.agents/SCHEMA.md` only if the task involves DB work
- Read `.agents/MAP.md` only if the task requires navigating unfamiliar modules
- Read `.agents/DECISIONS.md` only if the task touches architecture decisions

If user says "update map": read source dirs, update MAP.md, then resume.
If user says "show backlog": read TASKS.md Backlog section and display it.
