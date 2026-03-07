# MAP.md

Use this file as a guide to the codebase, not as a replacement for code inspection.
If the map contradicts the source, fix the map.

## Last verified
- Commit: [short-hash]
- Date: YYYY-MM-DD
- By: [Name / Claude / Codex]
<!-- apex-start compares this hash to git HEAD and warns if stale -->

---

## Top-Level Areas
| Path | Purpose | Notes |
| --- | --- | --- |
| `src/` | Application source | [key subfolders] |
| `tests/` | Automated tests | [framework] |
| `db/` | Schema and migrations | [tooling] |

<!-- Ejemplo:
| `src/api/` | REST handlers | Express routers, one file per resource |
| `src/services/` | Business logic | No direct DB access, uses repositories |
| `src/db/` | Repository layer | Prisma queries only here |
-->

## Key Modules
| Path | Responsibility | Depends On |
| --- | --- | --- |
| `src/...` | [module summary] | [services or modules] |

<!-- Ejemplo:
| `src/services/auth.ts` | JWT issue/verify, session management | `src/db/users.ts`, Redis |
| `src/api/payments.ts` | Stripe webhook handling | `src/services/billing.ts` |
-->

## Change Hotspots
- [path]: [why it changes often]

<!-- Ejemplo:
- `src/api/users.ts`: Frequent requirement changes from product
- `db/migrations/`: Every sprint has at least one schema change
-->

## Unknowns / Needs Audit
- [folder or module that still needs mapping]
