# End Session

Use this workflow to close a work session and update shared memory.

## Pre-commit Checklist

Before updating shared memory, verify the session leaves the codebase in a clean state:

- [ ] Code lints without errors (run `ruff check` / `eslint` as appropriate for the stack).
- [ ] Changed modules have tests that pass.
- [ ] No hardcoded secrets, tokens, or credentials introduced.
- [ ] Every commit in this session is atomic with a descriptive message.
- [ ] If a DB migration was written, `.agents/SCHEMA.md` reflects it.

If any item fails, fix it before proceeding.

## Gather Evidence
- Review the files changed in this session.
- Inspect the current task state.
- Check whether code changes invalidated `MAP.md`, `SCHEMA.md`, `CONTRACTS.md`, or `DECISIONS.md`.

## Update Shared Brain
1. Append a dated entry to `.agents/PROGRESS.md`:
   - completed work
   - work carried forward
   - decisions or surprises
2. Update `.agents/TASKS.md`:
   - mark completed tasks
   - move active tasks if priorities changed
   - add newly discovered work only if it is real and actionable
3. Update `.agents/MAP.md` for new modules or major responsibility changes.
4. Update `.agents/SCHEMA.md` for confirmed DB changes only.
5. Update `.agents/CONTRACTS.md` and `.agents/DECISIONS.md` if those changed.

## Output
- Summarize what was updated in shared memory.
- Provide a short commit message suggestion.
