# SCHEMA.md

This file documents the application-facing view of the database.
It is not the only source of truth.
Always verify schema changes against migrations, ORM definitions, and live constraints before editing.

## Última verificación
- Commit: [hash corto]
- Fecha: YYYY-MM-DD
- Verificado por: [Nombre / Claude / Codex]

---

## Sources of Truth
- Migrations: [path]
- ORM / schema definition: [path]
- DB platform notes: [path or "n/a"]

## Tables Overview
| Table | Purpose |
| --- | --- |
| [table_name] | [one line purpose] |

<!-- Ejemplo:
| users | Registered accounts |
| sessions | Active auth sessions (expires TTL) |
| audit_log | Immutable record of all write operations |
-->

## Table: [table_name]
**Purpose:** [why this table exists]

| Field | Type | Nullable | Default | Notes |
| --- | --- | --- | --- | --- |
| id | uuid | NO | gen_random_uuid() | Primary key |

<!-- Ejemplo:
## Table: users
**Purpose:** Stores registered user accounts and their preferences.

| Field | Type | Nullable | Default | Notes |
| --- | --- | --- | --- | --- |
| id | uuid | NO | gen_random_uuid() | Primary key |
| email | text | NO | — | Unique, lowercased on insert |
| role | text | NO | 'member' | 'member' \| 'admin' |
| created_at | timestamptz | NO | now() | — |

**Indexes:** `users_email_idx` (unique)
**Constraints:** `email` format check via trigger
**Relationships:** `sessions.user_id → users.id`
**RLS / Permissions:** Select allowed for own row; insert restricted to auth service
-->

**Indexes:** [index list]
**Constraints:** [constraint list]
**Relationships:** [FK relationships]
**RLS / Permissions:** [summary or "n/a"]

## Change Log
| Date | Change | Migration / PR | Author | Notes |
| --- | --- | --- | --- | --- |
