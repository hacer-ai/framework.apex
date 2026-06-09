---
name: apex-end
description: End the work session. Update all brain files with today's progress. Use when the user is done for the day, says "wrap up", "close session", or "end session".
---

Update the brain files to close this session. Follow these rules for every file you touch.

## TASKS.md
- Mark completed tasks [DONE] with today's date.
- Trim rule: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD` — delete all sub-bullets (code and git history hold the details).
- Move any [x] items out of "In Progress" to the Done section.
- New tasks found this session: scan highest existing T-NNN, increment by 1.

## PROGRESS.md
- If > 150 lines: archive sessions older than 2 weeks into a summary table at bottom (`| Session N | date | summary |`). Keep Milestones + last 5 sessions with full detail.
- Append today's entry: ✅ done · 🔄 carry-forward · 🧠 decisions · who did the work.

## MAP.md
- Add any new files or modules created this session. Update the "Last verified" hash and date.

## SCHEMA.md
- Only if DB changes were made: update affected tables, append a Change Log row.

## DECISIONS.md
- Add architectural decisions made this session. Scan for highest ADR-NNN, use that + 1. Append at END only. Never reuse an existing number.

## Rules (apply to all updates)
- No redundancy: don't duplicate info already in another brain file or CLAUDE.md.
- Unique IDs: T-NNN and ADR-NNN must never collide — always scan before creating.
- Completed work is immutable: DONE tasks are one-liners. Sessions >2 weeks old are archive material.

For each DONE task with a `[LIN: ABC-NNN]` tag not yet synced: run apex-linear-sync.

Output: `chore(apex): [YYYY-MM-DD] — [main thing accomplished]`
