# Init — Populate Shared Brain from the Real Codebase

Run this playbook **once**, immediately after installing the APEX scaffold.
Its job is to replace every placeholder in `.agents/` with real information
derived from reading the actual project. Do not invent — only write what you
can confirm by reading files.

---

## Step 1 — Detect the stack

Read the following files if they exist (check all in parallel):
- `package.json` / `package-lock.json` / `bun.lockb`
- `pyproject.toml` / `requirements.txt` / `poetry.lock`
- `go.mod` / `Cargo.toml` / `composer.json`
- `docker-compose.yml` / `docker-compose.yaml`
- `.env.example` / `.env.sample`
- `Dockerfile` / `fly.toml` / `render.yaml` / `vercel.json` / `netlify.toml`
- `.github/workflows/` (any CI files)
- `next.config.*` / `vite.config.*` / `astro.config.*` / `nuxt.config.*`

From these files extract:
- Frontend framework and version
- Backend runtime / framework and version
- Database type and driver/ORM
- Hosting platform
- External services (auth, storage, email, payments, etc.)
- Environment variables and what they control

## Step 2 — Map the codebase

Run a directory listing of the project root. Then for each top-level folder
with source code, list its immediate children. Identify:
- Where application source lives
- Where tests live
- Where DB migrations / schema definitions live
- Where configuration lives

Focus on folders with more than a few files. Do not map `node_modules`,
`.git`, build outputs, or generated files.

For each significant module or folder, read 1–2 key files to understand its
responsibility. Do not read everything — use file names and structure to infer
where needed.

## Step 3 — Ask about existing tasks

Before creating tasks, ask the user:

> "¿Ya tienes un listado de tareas o backlog en algún lado?
> Puedo importarlas en lugar de crear tareas genéricas. Opciones:
>
> 1. **Sí, tengo un archivo** — dime la ruta (ej. `docs/tasks.md`, `TODO.md`)
> 2. **Sí, tengo una exportación** — pégala aquí (Linear CSV, Jira export, Notion, texto libre)
> 3. **Sí, las dicto ahora** — descríbelas y las estructuro
> 4. **No, crea tareas de revisión** — solo crea las tareas genéricas de revisión del scaffold

Wait for the answer before writing `TASKS.md`.

### Si el usuario elige 1 (archivo):
- Lee el archivo indicado
- Extrae tareas, conviértelas al formato `T-NNN — [descripción] \`[LEAD]\``
- Asigna IDs correlativos empezando en T-001
- Coloca en la sección correcta (In Progress / Up Next / Backlog / Blocked) según el estado que tengan

### Si el usuario elige 2 (exportación pegada) o 3 (dicta ahora):
- Parsea el texto libre o la exportación
- Mapea cada ítem al formato estándar
- Infiere el estado (si no está claro, ponla en Backlog)
- Pide confirmación si hay ambigüedad en alguna tarea

### Si el usuario elige 4 (o no responde / dice que no):
- Crea solo las tareas de revisión del scaffold:
  - T-001: Revisar y corregir CONTEXT.md `[human]`
  - T-002: Revisar y corregir MAP.md `[human]`
  - T-003: Revisar y corregir SCHEMA.md `[human]` — solo si se detectó DB
  - T-004: [gap o riesgo detectado en el codebase, si aplica]

### En todos los casos:
- Agrega siempre al final de Done: `[x] T-000 — APEX scaffold instalado e inicializado`

---

## Step 4 — Detect the schema (if applicable)

Look for schema sources in this order:
1. `prisma/schema.prisma`
2. `db/migrations/` or `migrations/` — read the most recent 3 files
3. `drizzle/` schema files
4. `alembic/versions/` — most recent 3
5. ORM model files (`src/models/`, `app/models/`, etc.)

If none found, note "No DB detected" and skip SCHEMA.md population.

## Step 5 — Write the files

Write each file below using only confirmed information.
Use `[unknown — fill manually]` for anything you could not determine.
Never leave the original placeholder text (e.g. `[framework]`) in place.

### CONTEXT.md
Fill in:
- Project name (`__PROJECT_NAME__` is already replaced)
- Purpose: one sentence from README or inferred from the codebase
- Stack: every row with real values or `[unknown]`
- Services table: one row per external service detected
- Environments table: one row per variable found in `.env.example`
- Constraints: any hard limits found in docs or config (rate limits, plan limits, etc.)
- Known Risks: leave empty — this requires human judgment

### MAP.md
Fill in:
- Top-Level Areas: one row per meaningful folder
- Key Modules: one row per module whose responsibility is clear from reading
- Change Hotspots: infer from folder names and file count (large folders with
  generic names like `api/` or `handlers/` are usually hotspots)
- Unknowns / Needs Audit: list folders you could not clearly map
- Set "Última verificación" to today's date, current commit hash (`git rev-parse --short HEAD`), and `Claude (apex-init)`

### SCHEMA.md
If schema was found:
- Fill Sources of Truth with real paths
- Fill Tables Overview with every table detected
- Fill one `## Table:` section per table with real fields, types, and constraints
- Set "Última verificación" to today's date, current commit hash, and `Claude (apex-init)`

If no schema found:
- Write "No database detected during init. Fill manually if applicable."

### TASKS.md
Use the result from Step 3. Do not recreate tasks — write exactly what was
agreed with the user in that step.

### DECISIONS.md
Leave the ADR-001 template in place. Add a comment:
```
<!-- No decisions recorded during init. Add the first one when you make a non-obvious architectural choice. -->
```

### CONTRACTS.md
Leave the tables in place. Add a comment:
```
<!-- No contracts recorded during init. Add entries when stable interfaces between modules or teams are established. -->
```

### PROGRESS.md
Replace the placeholder session entry with a real one:
```
### YYYY-MM-DD · Claude (apex-init) · init
- ✅ Populated CONTEXT.md, MAP.md from codebase scan
- ✅ Populated SCHEMA.md (or: no DB detected)
- ✅ Tasks imported from [source] / created as review tasks
- 🔄 DECISIONS.md and CONTRACTS.md left for human review
- ⚠️ [any gaps or unknowns found]
```

---

## Step 6 — Output a summary

After writing all files, respond with:

```text
APEX INIT COMPLETE
Project: [name]
Stack: [short description, e.g. "Next.js 14 + Supabase + Vercel"]
Files written: CONTEXT.md, MAP.md, SCHEMA.md (or skipped), TASKS.md, PROGRESS.md
Tasks: [N imported from X / N review tasks created]
Unknowns: [list anything left as [unknown] or "none"]
Next: Review the files above, correct any mistakes, then run /apex-start to begin work.
```

---

## Rules
- Only write confirmed facts. `[unknown — fill manually]` is always better than a guess.
- Do not modify `AGENTS.md` or `CLAUDE.md` — those are user-owned.
- Do not create new files beyond what is listed above.
- If you find something that looks like a security risk (hardcoded secrets, open CORS, etc.), note it in PROGRESS.md under ⚠️ but do not alter production files.
