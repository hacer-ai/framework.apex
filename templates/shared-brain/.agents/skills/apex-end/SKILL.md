---
name: apex-end
description: End the current APEX development session by updating all context files. Use when the user says "end session", "wrap up", "closing", "done for today", or asks to update the project docs.
---

Update these files to close the session:
1. .agents/PROGRESS.md — Append today's entry (✅ done · 🔄 carry-forward · 🧠 decisions · who did the work)
2. .agents/TASKS.md — Mark [DONE] with date, remove 🔒 ACTIVO signals, add new tasks, re-prioritize
3. .agents/MAP.md — Add new files or modules created this session
4. .agents/SCHEMA.md — If DB changed: update tables + append Change Log row
5. .agents/DECISIONS.md — Add architectural decisions made

For each task marked DONE with a [LIN: ABC-NNN] tag not yet synced: call apex-linear-sync to mark it Done in Linear.

Output: chore(apex): [YYYY-MM-DD] — [main thing accomplished]
