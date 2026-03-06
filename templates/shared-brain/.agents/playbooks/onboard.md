# Onboard New Contributor

Use this workflow when a new person or agent joins the project for the first time.

## Read in Order
1. `AGENTS.md` or `CLAUDE.md` — entry point and operating rules
2. `.agents/CONTEXT.md` — stack, services, environments, constraints
3. `.agents/MAP.md` — codebase layout and key modules
4. `.agents/DECISIONS.md` — past decisions that explain the current shape of the code
5. `.agents/CONTRACTS.md` — stable interfaces not to break
6. `.agents/TASKS.md` — what is being worked on and by whom
7. `.agents/SCHEMA.md` — only if the person will touch data

## Setup Checklist
Go through this with the new contributor and confirm each item:

- [ ] Dev environment runs locally (or in the expected cloud environment)
- [ ] Can run the test suite
- [ ] Has access to required services (DB, secrets, third-party APIs)
- [ ] Understands the branch and PR convention
- [ ] Has read `DECISIONS.md` and has no unresolved questions about past choices
- [ ] Knows the `🔒 ACTIVO` convention in `TASKS.md`
- [ ] Knows how to run `start-session` and `end-session` playbooks

## Output
Respond with a compact onboarding summary:

```text
ONBOARDING COMPLETE
Contributor: [name or agent]
Stack understood: Yes / Partial (gaps: ...)
Setup blockers: [list or "none"]
First suggested task: [T-NNN from TASKS.md]
Open questions to resolve: [list or "none"]
```

## Rules
- Do not assign a task until setup blockers are resolved.
- If `CONTEXT.md` or `MAP.md` are stale, flag it — do not let a new contributor learn from stale docs.
- If the contributor is an agent (Claude / Codex), confirm which files it will auto-read at session start.
