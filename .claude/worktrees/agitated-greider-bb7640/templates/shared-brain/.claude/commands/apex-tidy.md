---
name: apex-tidy
description: Mechanical hygiene pass on the brain files — archive Done tasks > 14 days, compress old PROGRESS sessions, fix ID collisions, normalize formatting. Designed for cheap, fast models (Haiku). Run weekly or when TASKS.md exceeds 400 lines.
disable-model-invocation: true
---

You are running a **pure janitorial pass**. No new content, no decisions, no architectural advice. Only the operations listed below. If something is ambiguous, leave it as-is and report it under "needs human review" at the end.

## Today

Capture today's date as `YYYY-MM-DD` from the system. Use it for any "newer than" comparisons.

## Operations

### 1. TASKS.md — archive old Done

Read `.agents/TASKS.md`.

For every task in the **Done** section with `DONE YYYY-MM-DD` more than **14 days** older than today:
1. Append the line verbatim to `.agents/archive/TASKS-YYYY-MM.md` (file scoped to the month the task was Done; create directory and file if missing — start the file with `# Archived tasks — YYYY-MM\n\n`).
2. Delete the line from `TASKS.md`.

Preserve original ordering inside the archive file (oldest first).

### 2. TASKS.md — section integrity

For every state section (Todo, In Progress, Human Review, Rework, Done, Backlog, Blocked):
- Items marked `[x]` that are **not** in Done → move to Done (append, with today's date and any existing `[PR: #...]` / `[@hash]` tag preserved).
- Items in Done that are **not** marked `[x]` → mark `[x]`.
- Items in In Progress without a `🔒 ACTIVO:` marker AND without commits in the last 7 days against any file mentioned in their Notes → flag under "needs human review" (do not move).

### 3. TASKS.md — ID collisions

Scan all `T-NNN` IDs. If any number appears more than once:
- Keep the first occurrence with its number.
- Renumber subsequent occurrences to the next free number above the current max.
- Report each renumber under "renumbered".

Same rule for `ADR-NNN` in `.agents/DECISIONS.md`.

### 4. TASKS.md — formatting normalize

For each task line, ensure the order of tags is: `T-NNN` → `[LIN: ...]` (if any) → `—` → title → `` `[LEAD]` `` → `[CONTRACTOR: ...]` (if any). Reorder if needed. Do not invent missing tags. Do not change titles.

### 5. PROGRESS.md — archive old sessions

Read `.agents/PROGRESS.md`.

If the file exceeds 150 lines:
- Keep the Milestones section verbatim.
- Keep the most recent **5** session entries with full detail.
- For every older session, append one row to the Archive table at the bottom: `| YYYY-MM-DD · Author · type | one-line summary distilled from the bullets |`. The summary must be ≤ 100 chars and contain **no new information** — only condensed restatement.
- Delete the original detailed entry.

### 6. Done

After all operations, write a single block to stdout:

```
✓ APEX-TIDY — YYYY-MM-DD
archived:    N tasks → .agents/archive/
progress:    M sessions compressed
renumbered:  list of T-NNN / ADR-NNN changes (or "none")
formatting:  K lines normalized
needs human review:
  - [bullet per item]
```

Do **not** write to MAP.md, SCHEMA.md, DECISIONS.md (beyond ID collisions), CONTEXT.md, CLAUDE.md, or AGENTS.md. Do **not** add commentary, suggestions, or new tasks. Do **not** call Linear. This pass is offline-only.

## Cost optimization

This command is mechanical and bounded. Run it on a cheap model:

```sh
claude -p --model claude-haiku-4-5-20251001 "/apex-tidy"
```

Or use the helper: `./scripts/apex-tidy.sh` (resolves to the same Haiku invocation).
