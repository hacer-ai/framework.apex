---
name: apex-schema
description: Guard against unsafe database changes. Auto-invoke whenever the task involves creating a migration, adding a column, changing a table, writing a DB query, modifying an ORM model, or any database schema work. Trigger phrases include: "add column", "create table", "migration", "schema change", "alter table", "new table", "foreign key", "FK", "index", "drizzle schema", "prisma schema", "supabase migration".
allowed-tools: Read, Write
---

Read .agents/SCHEMA.md and .agents/CONTRACTS.md first.

DB change requested: $ARGUMENTS

Before writing any migration or query, analyze:
1. **Affected tables** — which SCHEMA.md tables are touched?
2. **Relationship impact** — does this break or require updating FK relationships?
3. **Constraint conflicts** — conflicts with existing unique/check constraints?
4. **Downstream impact** — which CONTRACTS.md endpoints or MAP.md modules query these tables?
5. **Destructive?** — column removal, type change, or rename? State the rollback path.
6. **RLS impact** — if Supabase, are existing RLS policies still valid after this change?

Propose the migration plan. Wait for explicit approval before writing any migration files.
After approval and execution: update .agents/SCHEMA.md entries and append to the Change Log.
