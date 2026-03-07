---
name: apex-schema
description: Guard against unsafe database changes. Auto-invoke for any task involving migrations, schema changes, adding columns, creating tables, modifying ORM models, or any database structure work. Trigger phrases: "add column", "create table", "migration", "schema change", "alter table", "drizzle", "prisma schema".
---

Read .agents/SCHEMA.md and .agents/CONTRACTS.md.

DB change: $ARGUMENTS

Analyze before writing anything:
1. Affected tables in SCHEMA.md
2. FK relationship impact
3. Constraint conflicts
4. Downstream CONTRACTS.md / MAP.md impact
5. Destructive? (removal, type change, rename) — state rollback path
6. RLS policy validity (if Supabase)

Propose migration. Wait for approval.
After execution: update SCHEMA.md + append Change Log row.
