---
name: apex-end
description: End the work session. Update all brain files with today's progress. Use when done for the day or wrapping up.
---

Update the brain files to close this session.

## TASKS.md
- Mark completed tasks [DONE] with today's date.
- Trim rule: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD` — delete all sub-bullets.
- Move any [x] items out of "In Progress" to the Done section.
- New tasks found this session: scan highest existing T-NNN, increment by 1.

## PROGRESS.md
- If > 150 lines: archive sessions older than 2 weeks into a summary table at bottom. Keep Milestones + last 5 sessions.
- Append today's entry: ✅ done · 🔄 carry-forward · 🧠 decisions · who did the work.

## MAP.md
- Add any new files or modules created this session.

## SCHEMA.md
- Only if DB changes were made: update affected tables, append a Change Log row.

## DECISIONS.md
- Add architectural decisions made this session. Scan for highest ADR-NNN, use that + 1. Append at END only.

## Rules
- No redundancy across brain files.
- Unique IDs: T-NNN and ADR-NNN must never collide.
- Completed work is immutable: DONE tasks are one-liners. Sessions >2 weeks old are archive material.

For each DONE task with a `[LIN: ABC-NNN]` tag not yet synced: call apex-linear-sync.

Output: `chore(apex): [YYYY-MM-DD] — [main thing accomplished]`
