# CONTEXT.md

## Project
- Name: __PROJECT_NAME__
- Status: ACTIVE
- Purpose: [one sentence]

## Tracker integration

| Setting | Value | Notes |
| --- | --- | --- |
| LINEAR_MODE | mirror | `source` · `mirror` · `off` — see below |
| Linear Team ID | [TEAM-CODE] | Linear → Settings → General |
| Linear Project | [project-name] | Linear project the team works in |

**LINEAR_MODE values**

- `source` — Linear is the team's source of truth. `/apex-sync` pulls from Linear into TASKS.md before each session. Recommended for teams of 2+ where non-engineers also create tickets.
- `mirror` — TASKS.md is local-first; changes are pushed to Linear when tasks move state. Recommended for solo work that wants Linear as a durable archive. (Default.)
- `off` — Linear is not used. All Linear skills no-op. Recommended for personal projects or when Linear MCP is not configured.

## Stack
- Frontend: [framework]
- Backend: [framework or runtime]
- Database: [database]
- ORM / Query Layer: [tool]
- Hosting: [platform]

## Services
| Service | Purpose | Notes |
| --- | --- | --- |
| [service] | [reason] | [owner, auth, limits] |

## Environments
| Variable | Scope | Notes |
| --- | --- | --- |
| [ENV_VAR] | [local/staging/prod] | [what it controls] |

## Constraints
- [business or technical constraint]

## Known Risks
- [ongoing risk]
