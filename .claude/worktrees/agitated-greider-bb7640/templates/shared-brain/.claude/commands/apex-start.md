---
name: apex-start
description: Begin a work session. Load tasks and session status. Use when starting work or saying "let's begin", "what should I work on", "start session".
disable-model-invocation: true
---

Read `.agents/CONTEXT.md` first. Resolve `LINEAR_MODE` (default: `mirror`).

**If `LINEAR_MODE=source`**: run `/apex-sync` and wait for it to finish before continuing. This pulls any Linear-side changes into TASKS.md.

Read these files silently:
1. `.agents/TASKS.md` — Todo, In Progress, and Human Review sections only (stop before Rework)
2. `.agents/PROGRESS.md` — last entry only

Run: `git log --oneline -1`. Note HEAD hash (first 7 chars). If MAP.md has a "Last verified:" line with a different hash, mark as stale.

Health checks (silent, report warnings in output):
- "In Progress" has items marked [x] or DONE → warn stale tasks stuck in wrong section
- TASKS.md > 400 lines → warn bloat, suggest `/apex-tidy`

Respond ONLY with this block:

---
✓ SESSION LOADED
Project: [name] · Mode: [mode] · Linear: [source/mirror/off]
Last completed: [last PROGRESS.md entry, one line]
Blocked: [blocked tasks or "none"]
[if stale: ⚠ MAP.md stale (was: abc1234 · now: def5678) — say "update map" to fix]
[if health warnings: one line each]

**In Progress:** T-NNN — title
**Human Review:** T-NNN — title (if any)
**Up Next (Todo):** T-NNN — title

Which task? (T-ID · "show backlog" · "add task: [description]")
---

Wait for task selection before reading any other files or writing code.

On task selection:
- Move task to In Progress in TASKS.md if not already there
- If `[LIN: ABC-NNN]` tag exists AND `LINEAR_MODE != off`, sync Linear status via `apex-linear-sync`
- Read `.agents/SCHEMA.md` only if the task involves DB work
- Read `.agents/MAP.md` only if the task requires navigating unfamiliar modules
- Read `.agents/DECISIONS.md` only if the task touches architecture decisions

If user says "update map": read source dirs, update MAP.md + Last verified line, then resume.
If user says "show backlog": read TASKS.md Backlog section and display it.
