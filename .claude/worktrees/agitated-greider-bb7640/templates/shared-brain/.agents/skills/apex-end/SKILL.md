---
name: apex-end
description: End the work session. Update all brain files with today's progress. Use when done for the day or wrapping up.
---

Update the brain files to close this session.

## TASKS.md

State transitions:
1. Implementation committed locally, no PR yet → **Human Review** (if PR coming) or **Done** with `[@<short-sha>]` proof.
2. Merged or shipped → **Done**, marked `[x]`, with `[PR: #N]` or `[@hash]`.
3. Came back from review with feedback → **Rework**.
4. Trim Done to: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD [PR: #N | @hash]`. Delete sub-bullets.

**PR-proof gate**: if marking Done without `[PR: #N]` or `[@<sha>]`, do not mark Done. Ask the user.

New tasks discovered: scan highest T-NNN, +1.

## PROGRESS.md
- If > 150 lines: archive sessions > 2 weeks old to the Archive table. Keep Milestones + last 5 sessions detailed. (Or run `apex-tidy`.)
- Append: ✅ done · 🔄 carry-forward · 🧠 decisions · who did the work.

## MAP.md
- Add any new files or modules.
- Update `Last verified:` with current HEAD short hash + today's date.

## SCHEMA.md
- Only if DB changes: update tables, append Change Log row.

## DECISIONS.md
- Add ADRs from this session. Highest ADR-NNN + 1. Append at END.

## Linear sync

For each task that changed state with `[LIN: ABC-NNN]` AND `LINEAR_MODE != off`: call `apex-linear-sync`.

If `LINEAR_MODE=source`, run `apex-sync` at the end.

## Rules
- No redundancy. Unique IDs. Done tasks are one-liners. Old sessions are archive.

Output: `chore(apex): [YYYY-MM-DD] — [main thing]`
