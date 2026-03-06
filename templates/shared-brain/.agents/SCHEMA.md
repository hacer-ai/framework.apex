# SCHEMA.md

This file documents the application-facing view of the database.
It is not the only source of truth.
Always verify schema changes against migrations, ORM definitions, and live constraints before editing.

## Sources of Truth
- Migrations: [path]
- ORM / schema definition: [path]
- DB platform notes: [path or "n/a"]

## Tables Overview
| Table | Purpose |
| --- | --- |
| [table_name] | [one line purpose] |

## Table: [table_name]
**Purpose:** [why this table exists]

| Field | Type | Nullable | Default | Notes |
| --- | --- | --- | --- | --- |
| id | uuid | NO | gen_random_uuid() | Primary key |

**Indexes:** [index list]
**Constraints:** [constraint list]
**Relationships:** [FK relationships]
**RLS / Permissions:** [summary or "n/a"]

## Change Log
| Date | Change | Migration / PR | Notes |
| --- | --- | --- | --- |
