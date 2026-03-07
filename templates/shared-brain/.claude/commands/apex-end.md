Update these files to close the session:

1. **.agents/PROGRESS.md** — Append an entry for today:
   - What was completed (✅)
   - What was started but not finished (🔄)
   - Any decisions or surprises (🧠)
   - Who did the work (human name, Claude, or Codex)

2. **.agents/TASKS.md** — Update statuses:
   - Mark completed tasks [DONE] with today's date, remove 🔒 ACTIVO signal
   - Add any new tasks discovered this session
   - Re-prioritize if needed

3. **.agents/MAP.md** — Add any new files or modules created this session

4. **.agents/SCHEMA.md** — Only if DB changes were made:
   - Update affected table entries
   - Append a row to the Change Log section

5. **.agents/DECISIONS.md** — Add any architectural decisions made this session

For each task marked DONE that has a `[LIN: ABC-NNN]` tag and has not been synced yet:
- Call apex-linear-sync to mark it Done in Linear

Output a ready-to-use git commit message:
`chore(apex): [YYYY-MM-DD] — [main thing accomplished]`
