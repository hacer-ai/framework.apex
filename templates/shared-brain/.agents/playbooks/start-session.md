# Start Session

Use this workflow when the user asks to start work, resume context, or decide what to do next.

## Read First
1. `AGENTS.md` or `CLAUDE.md`
2. `.agents/CONTEXT.md`
3. `.agents/MAP.md`
4. `.agents/TASKS.md`
5. `.agents/PROGRESS.md`
6. `.agents/DECISIONS.md` when prior architectural choices matter

## Output
Respond with a compact session handoff:

```text
SESSION LOADED
Project: [name] · Mode: [mode]
Last completed: [most recent completed item]
Active task: [current highest-priority task]
Blocked: [blocked items or "none"]
Risks: [key risk or "none"]
```

## Execution Rules
- Use `TASKS.md` to pick the current task, but verify the relevant code before acting.
- If the top task touches data, auth, or external contracts, load the relevant shared doc before editing.
- If `TASKS.md` is clearly stale, say so and propose the smallest update needed.
