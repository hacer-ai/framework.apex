---
name: apex-tidy
description: Pure janitorial pass on brain files — archive Done tasks > 14 days, compress old PROGRESS sessions, fix ID collisions, normalize formatting. No new content, no decisions. Run weekly or when TASKS.md exceeds 400 lines. Trigger phrases: "tidy brain", "clean tasks", "archive done", "apex tidy".
---

You are running a **pure janitorial pass**. No new content, no decisions, no architectural advice. Only the operations listed. If something is ambiguous, leave it and report under "needs human review".

## Today

Capture today's date as `YYYY-MM-DD`. Use it for "newer than" comparisons.

## Operations

### 1. TASKS.md — archive old Done

Read `.agents/TASKS.md`.

For every task in the Done section with `DONE YYYY-MM-DD` more than **14 days** older than today:
1. Append verbatim to `.agents/archive/TASKS-YYYY-MM.md` (scope by the month the task was Done; create the file if missing with header `# Archived tasks — YYYY-MM\n\n`).
2. Delete the line from `TASKS.md`.

Preserve oldest-first ordering inside the archive file.

### 2. TASKS.md — section integrity

For every state section (Todo, In Progress, Human Review, Rework, Done, Backlog, Blocked):
- `[x]` items NOT in Done → move to Done with today's date, preserving any `[PR: #...]` / `[@hash]` tag.
- Items in Done NOT marked `[x]` → mark `[x]`.
- Items in In Progress without `🔒 ACTIVO:` AND without recent commits referencing their Notes files → flag under "needs human review" (do not move).

### 3. ID collisions

Scan `T-NNN` and `ADR-NNN`. If any number repeats:
- Keep the first occurrence.
- Renumber later occurrences to the next free number above the current max.
- Report each renumber.

### 4. Formatting normalize

Tag order on each task: `T-NNN` → `[LIN: ...]` (if any) → `—` → title → `` `[LEAD]` `` → `[CONTRACTOR: ...]` (if any). Reorder if needed. Do not invent missing tags. Do not change titles.

### 5. PROGRESS.md — archive old sessions

If `.agents/PROGRESS.md` exceeds 150 lines:
- Keep Milestones section verbatim.
- Keep the 5 most recent session entries with full detail.
- For every older session, append a row to the Archive table: `| YYYY-MM-DD · Author · type | ≤100-char distilled summary |`. No new information.
- Delete the original detailed entry.

### 6. Report

Write to stdout:

```
✓ APEX-TIDY — YYYY-MM-DD
archived:    N tasks → .agents/archive/
progress:    M sessions compressed
renumbered:  list (or "none")
formatting:  K lines normalized
needs human review:
  - [bullet per item]
```

Do **not** touch MAP.md, SCHEMA.md, DECISIONS.md (except ID collisions), CONTEXT.md, AGENTS.md. Do **not** add commentary. Do **not** call Linear.
