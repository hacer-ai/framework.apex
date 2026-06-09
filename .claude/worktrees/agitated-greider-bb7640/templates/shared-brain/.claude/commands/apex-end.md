---
name: apex-end
description: End the work session. Update all brain files with today's progress. Use when done for the day or wrapping up.
disable-model-invocation: true
---

Update the brain files to close this session. Follow these rules for every file you touch.

## TASKS.md

**State transitions for tasks worked this session:**

1. Tasks where the implementation is committed locally but no PR is open → move to **Human Review** (if a PR is being prepared) or directly to **Done** if a commit hash is the proof. The task line must end with one of:
   - `[PR: #N]` — pull request reference
   - `[@<short-sha>]` — short commit hash (7 chars from `git rev-parse --short HEAD`)
2. Tasks fully merged or shipped → **Done**, marked `[x]`, with date and proof tag.
3. Tasks that came back from review with feedback → **Rework**.
4. Trim Done lines to: `- [x] T-NNN — Title [Lead] DONE YYYY-MM-DD [PR: #N | @hash]`. Delete sub-bullets — git history holds the details.

**PR-proof gate**: if a task is being marked Done without `[PR: #N]` or `[@<sha>]`, **do not mark it Done**. Ask the user: "T-NNN has no PR or commit hash — provide one or move it to Human Review?"

**New tasks discovered this session**: scan highest existing T-NNN, increment by 1.

## PROGRESS.md
- If > 150 lines: archive sessions older than 2 weeks into the Archive table at bottom. Keep Milestones + last 5 sessions with full detail. (Or run `/apex-tidy` afterward.)
- Append today's entry: ✅ done · 🔄 carry-forward · 🧠 decisions · who did the work.

## MAP.md
- Add any new files or modules created this session.
- Update `Last verified:` line with current HEAD short hash and today's date.

## SCHEMA.md
- Only if DB changes were made: update affected tables, append a Change Log row.

## DECISIONS.md
- Add architectural decisions made this session. Scan for highest ADR-NNN, use that + 1. Append at END only.

## Linear sync

For each task that **changed state** this session AND has a `[LIN: ABC-NNN]` tag AND `LINEAR_MODE != off`:
- Call `apex-linear-sync` for that task.

If `LINEAR_MODE=source`, also run `/apex-sync` at the very end to reconcile any drift.

## Rules
- No redundancy across brain files.
- Unique IDs: T-NNN and ADR-NNN must never collide.
- DONE tasks are one-liners. Sessions > 2 weeks old are archive material.

Output: `chore(apex): [YYYY-MM-DD] — [main thing accomplished]`
