---
name: apex-init
description: One-time APEX setup. Reads the real codebase and fills every .agents/ brain file. Run manually with /apex-init right after installing the scaffold.
disable-model-invocation: true
---

Populate the shared brain from the real codebase. This runs **once**, right after install.
Do not invent — only write what you can confirm by reading files. Do not skip steps.

## Step 1 — Detect the stack → CONTEXT.md

Read whichever of these exist (check in parallel):
- `package.json` / lockfiles · `pyproject.toml` / `requirements.txt` · `go.mod` · `Cargo.toml` · `composer.json`
- `docker-compose.yml` · `Dockerfile` · `.env.example` / `.env.sample`
- `fly.toml` / `render.yaml` / `vercel.json` / `netlify.toml` · `.github/workflows/`
- `next.config.*` / `vite.config.*` / `astro.config.*` / `nuxt.config.*`

Extract: frontend framework, backend runtime, database + ORM, hosting platform,
external services (auth, storage, email, payments), env vars and what they control.

Write `.agents/CONTEXT.md` — replace every placeholder. Leave `[unknown]` where you genuinely can't confirm.

## Step 2 — Map the codebase → MAP.md

List the project root, then the immediate children of each source folder.
Skip `node_modules`, `.git`, build outputs, generated files.

Identify: where app source lives, where tests live, where migrations/schema live, where config lives.
For each significant module, read 1–2 key files to confirm its responsibility — do not read everything.

Write `.agents/MAP.md`, including the **Last verified** block: current `git log --oneline -1` short hash, today's date, "Claude".

## Step 3 — Schema (only if a database was detected) → SCHEMA.md

Read migrations, ORM models, or schema definition files.
Write `.agents/SCHEMA.md`: tables, fields, relationships, constraints.
If no database exists, leave the template in place and add a note: "No database detected · YYYY-MM-DD".

## Step 4 — Ask about existing tasks → TASKS.md

Before writing TASKS.md, ask the user and **wait for the answer**:

> Do you already have a task list or backlog somewhere?
> 1. **A file in this repo** — give me the path (e.g. `TODO.md`, `docs/tasks.md`)
> 2. **An export** — paste it here (Linear CSV, Jira, Notion, free text)
> 3. **Dictate them now** — describe them and I'll structure them
> 4. **No** — just create the default scaffold-review tasks

For options 1–3: convert each item to `- [ ] T-NNN — title `[LEAD]``, assign sequential IDs from T-001,
place in the correct section (In Progress / Up Next / Backlog / Blocked) by status; if unclear, use Backlog.

For option 4 (or no answer): create only
- T-001 — Review and correct CONTEXT.md `[human]`
- T-002 — Review and correct MAP.md `[human]`
- T-003 — Review and correct SCHEMA.md `[human]` (only if a DB was detected)
- plus one task per concrete gap or risk found in the codebase, if any

In all cases, end the Done section with: `- [x] T-000 — APEX scaffold installed and initialized`

## Step 5 — Report

Summarize per file: what was written, and what still needs human review.
Then suggest running `/apex-start` to begin the first session.
