# __PROJECT_NAME__ — CLAUDE.md

@AGENTS.md

## Claude Code

All shared rules live in AGENTS.md (imported above) — edit that file, not this one,
so Codex and Claude Code stay aligned.

Slash commands (skills in `.claude/skills/`):
- `/apex-init` — one-time setup: fill brain files from the real codebase
- `/apex-start` — begin session: load tasks, pick what to work on
- `/apex-end` — close session: update brain files
- `/apex-schema` — DB change guard; also auto-fires on DB phrases
- `/apex-linear-bootstrap` — push all tasks to Linear (once, after `/mcp` auth)
