Read the following files silently, in order:
1. CLAUDE.md
2. .agents/CONTEXT.md
3. .agents/MAP.md
4. .agents/TASKS.md
5. .agents/PROGRESS.md

Then run: `git log --oneline -1`
Note the current HEAD commit hash (first 7 characters).

Check MAP.md and SCHEMA.md for a "Last verified:" or "Updated:" line containing a commit hash.
If the stored hash differs from HEAD, mark those files as stale.

Then respond ONLY with this block — nothing else:

---
✓ SESSION LOADED
Project: [name from CLAUDE.md] · Mode: [mode]
Last completed: [most recent PROGRESS.md entry, one line]
Blocked: [blocked tasks or "none"]
[if stale files: ⚠️  MAP.md stale (last verified: abc1234 · now: def5678) — type "update map" to fix before editing]

## Tasks
**In Progress:**
[for each: T-NNN — title (one line of what needs to happen)]

**Up Next:**
[for each: T-NNN — title (one line of what needs to happen)]

Which task? (T-ID to pick · "show backlog" · "add task: [description]")
---

Wait for the user to select a task or add a new one before starting any work.

When the user picks a task:
- Move it to In Progress in .agents/TASKS.md if not already there
- If it has a `[LIN: ABC-NNN]` tag, call apex-linear-sync to update Linear
- If it touches the database, read .agents/SCHEMA.md before writing any code
- Do not read files outside MAP.md scope unless the task explicitly requires it

If the user types "update map":
- Read the actual source directory structure
- Update .agents/MAP.md to match current reality
- Update the "Last verified" line with today's date and current HEAD hash
- Then resume the session
