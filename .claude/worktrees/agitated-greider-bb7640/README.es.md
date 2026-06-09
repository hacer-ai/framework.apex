# APEX — Cerebro compartido para equipos que codean con IA

> **Una capa de memoria en archivos que mantiene a tu equipo y a tus agentes de IA en la misma página — menos tokens por sesión, menos "espera, ¿en qué iba?", una sola fuente de verdad entre Claude Code, Codex y Linear.**

🇺🇸 [Read in English](README.md)

---

## Por qué existe APEX

Cada sesión con un agente de IA empieza igual: el agente vuelve a leer archivos que ya conoce, vuelve a preguntar cosas que ya respondió, y vuelve a debatir decisiones de arquitectura que ya cerraste. Multiplicá eso por dos o tres agentes y un equipo chico — y el costo en tokens, en atención y en contexto perdido se vuelve feo rápido.

APEX le da al proyecto **un cerebro compartido en disco**: un set chico de archivos markdown pre-digeridos (`.agents/`) que cada agente lee en lugar de escanear el código fuente. Dos resultados:

1. **Menor consumo de tokens.** Un `MAP.md` de 2 KB reemplaza cientos de lecturas de archivo. Un `DECISIONS.md` de 1 KB termina discusiones antes de que vuelvan a empezar. La mayoría de las sesiones cargan menos de 5 KB de contexto antes de hacer trabajo real.
2. **Equipos sincronizados.** Humanos, Claude Code y Codex leen y escriben el mismo cerebro. Linear es la capa que ve el equipo completo — APEX mantiene `TASKS.md` y Linear sincronizados para que las personas no técnicas vean el estado real sin tocar el repo.

APEX **no** es una plataforma de orquestación como Symphony de OpenAI — es la capa de abajo. Si Symphony es "gestiona el trabajo, no a los agentes", APEX es "dale a los agentes un cerebro desde dónde gestionar". Devs solos y equipos chicos (2 a 5 personas) pueden correr APEX sin infraestructura; equipos más grandes pueden mantener APEX y poner Symphony arriba.

---

## Setup en dos pasos

### 1. Instalar el scaffold

```sh
./scripts/install-apex.sh /ruta/a/tu/proyecto --project-name "Mi Proyecto"
```

O en el directorio actual:

```sh
./scripts/install-apex.sh .
```

Para ver instrucciones de configuración del MCP de Linear en el output del install:

```sh
./scripts/install-apex.sh . --linear
```

**`CLAUDE.md`, `AGENTS.md` y los archivos del cerebro en `.agents/` nunca se sobrescriben** — esos pasan a ser tuyos después de la primera instalación. Los archivos del framework (slash commands, skills) se refrescan con `--force`.

### 2. Inicializar el cerebro

Abrí Claude Code dentro del proyecto y corré:

```
/apex-init
```

Claude lee el código real y llena `.agents/` automáticamente:
- Detecta stack, servicios, variables de entorno → escribe `CONTEXT.md`
- Mapea carpetas y módulos → escribe `MAP.md`
- Lee migraciones y modelos del ORM → escribe `SCHEMA.md` (si hay BD)
- Pregunta por las tareas existentes antes de escribir `TASKS.md`

Para proyectos sin código todavía, usá los prompts de bootstrap en la pestaña **Setup** de `index.html`.

---

## Flujo diario

```
/apex-start
```

Carga la lista de tareas activas y muestra qué falta hacer:

```
✓ SESSION LOADED
Project: Mi App · Mode: ACTIVE · Linear: source
Last completed: T-011 — Auth migration
Blocked: none

In Progress:    T-012 — Rotación de refresh tokens JWT
Human Review:   T-009 — Rate limiting (PR #57)
Up Next (Todo): T-013 — Idempotency keys, T-014 — Página de detalle de caso

Which task? (T-ID · "show backlog" · "add task: [descripción]")
```

Elegí una tarea o agregá una nueva. Los archivos del cerebro (`MAP.md`, `CONTEXT.md`, `DECISIONS.md`) se cargan **bajo demanda** — solo cuando la tarea seleccionada los necesita. Ahí es donde está la mayor parte del ahorro de tokens.

```
/apex-end
```

Actualiza `TASKS.md`, `PROGRESS.md`, `MAP.md`, `SCHEMA.md` y `DECISIONS.md`. Pushea los cambios de estado a Linear. **No deja marcar una tarea como Done sin un tag de prueba**: `[PR: #N]` o `[@<short-sha>]`.

| Cuándo | Comando | Qué pasa |
| --- | --- | --- |
| Setup inicial | `/apex-init` | Llena `.agents/` desde el código real |
| Empezar a trabajar | `/apex-start` | Carga la lista de tareas (lazy), elegís una |
| Trabajo de BD | (automático) | `apex-schema` se dispara con frases de BD |
| Agregar tarea | "add task: [desc]" | La crea en TASKS.md (y Linear) |
| Cerrar sesión | `/apex-end` | Actualiza el cerebro, exige prueba para Done |
| Sincronizar con el equipo | `/apex-sync` | Pull desde Linear + push de cambios de estado |
| Limpieza semanal | `/apex-tidy` | Archiva Done viejos, comprime logs (barato con Haiku) |

---

## Modelo de tareas

`TASKS.md` es el **buffer** entre Linear y la sesión activa. Usa una máquina de estados simple:

```
Todo  →  In Progress  →  Human Review  →  Done
                    ↑           │
                    └─── Rework ┘
```

Más dos áreas de espera: **Backlog** (sin agendar) y **Blocked** (esperando algo externo).

Una tarea solo entra a Done con prueba: `[PR: #N]` (pull request) o `[@<short-sha>]` (commit). Espeja el principio de "proof of work" de Symphony, pero a nivel archivo — sin infraestructura.

---

## Integración con Linear

Linear es **opcional pero soportada como capa de primera clase**. Configurá `LINEAR_MODE` en `.agents/CONTEXT.md`:

| Modo | Comportamiento | Cuándo usarlo |
| --- | --- | --- |
| `source` | Linear es la fuente de verdad del equipo. `/apex-start` corre `/apex-sync` primero. | Equipos de 2+, especialmente si gente no técnica crea tickets |
| `mirror` | TASKS.md es local-first; el estado se pushea a Linear en cada transición. (Default.) | Trabajo solo que quiere un archivo durable |
| `off` | Linear no se usa. Las skills de Linear no hacen nada. | Proyectos personales |

`/apex-sync` es bidireccional e idempotente: trae issues de Linear con label `apex` o asignados a vos hacia `TASKS.md`, y pushea cualquier cambio de estado local de vuelta. Corrélo al inicio de una sesión compartida, o cuando un compañero agregue un ticket desde la UI de Linear.

Configurá el MCP de Linear una vez por máquina:

```sh
claude mcp add-json linear '{"command":"npx","args":["-y","mcp-remote","https://mcp.linear.app/sse"]}'
```

Después autenticate en Claude Code: `/mcp` → seguí el flujo OAuth.

---

## Limpieza barata con Haiku

`/apex-tidy` es una pasada puramente mecánica — archiva tareas Done con más de 14 días, comprime sesiones viejas de `PROGRESS.md`, arregla colisiones de `T-NNN` / `ADR-NNN`, normaliza el formato. No escribe contenido nuevo y no toma decisiones. Eso lo hace ideal para un modelo barato y rápido.

Corrélo headless con Haiku para minimizar el costo:

```sh
claude -p --model claude-haiku-4-5-20251001 "/apex-tidy"
```

Metelo en un cron (domingos a la noche) o un hook pre-push de git, y tu cerebro se mantiene prolijo sin gastar tokens de Opus en limpieza.

---

## Worktrees para trabajo en paralelo

Claude Code soporta git worktrees nativamente. APEX se lleva bien con ellos: cada worktree comparte el mismo `.agents/`, así que dos agentes en branches distintos no pelean por `TASKS.md`. Marcá la tarea activa con `🔒 ACTIVO: <nombre> · YYYY-MM-DD` para que el otro lado vea quién tiene qué.

Para el modelo "workspace aislado por issue" estilo Symphony, un worktree por issue de Linear es prácticamente gratis y se alinea con el resto del flujo.

---

## Referencia de comandos

| Comando | Dónde | Qué hace |
| --- | --- | --- |
| `/apex-init` | Claude Code | Setup único — llena `.agents/` desde el código |
| `/apex-start` | Claude Code / Codex | Carga lista de tareas (lazy); corre `/apex-sync` primero si `LINEAR_MODE=source` |
| `/apex-end` | Claude Code / Codex | Actualiza el cerebro; exige `[PR: #N]` o `[@hash]` para Done |
| `/apex-sync` | Claude Code / Codex | Reconcile bidireccional con Linear (pull + push) |
| `/apex-tidy` | Claude Code / Codex | Archiva Done > 14 días, comprime logs, arregla colisiones (correr en Haiku) |
| `apex-schema` | Auto-invocado | Guard de cambios de BD — se dispara con frases de migración/schema |
| `apex-linear-bootstrap` | Manual | Push inicial de todas las tareas a Linear |
| `apex-linear-add` | Auto-invocado en "add task" | Crea tarea en TASKS.md (y Linear) |
| `apex-linear-sync` | Llamado por otras skills | Pushea el cambio de estado de una tarea a Linear |

### Auto-invocación
`apex-schema` se instala como skill en `.claude/skills/apex-schema/`, así que se dispara solo cuando decís cosas como "agregar columna", "migración", "create table" o "alter table". También se puede llamar directo como `/apex-schema`.

### Tip de contexto
Corré `/compact` a mitad de sesión si la ventana de contexto se está llenando. El compactor builtin resume el historial sin perder el estado de trabajo.

---

## Archivos del cerebro compartido

| Archivo | Propósito | Dueño |
| --- | --- | --- |
| `CONTEXT.md` | Stack, servicios, env vars, `LINEAR_MODE`, restricciones | Vos |
| `MAP.md` | Mapa del código — leerlo, nunca escanear carpetas | Vos |
| `SCHEMA.md` | Todas las tablas, campos, relaciones, change log | Vos |
| `TASKS.md` | Cola del sprint con IDs T-NNN y de Linear | Vos |
| `PROGRESS.md` | Log de sesiones con atribución | Vos |
| `DECISIONS.md` | Architecture Decision Records | Vos |
| `CONTRACTS.md` | Interfaces estables entre módulos (opcional, > 10 endpoints) | Vos |
| `archive/` | Auto-poblada por `/apex-tidy` | Framework |

---

## Layout del scaffold

```text
tu-proyecto/
├── AGENTS.md                        ← Entry point de Codex
├── CLAUDE.md                        ← Entry point de Claude Code
├── .agents/
│   ├── CONTEXT.md
│   ├── MAP.md
│   ├── SCHEMA.md
│   ├── TASKS.md
│   ├── PROGRESS.md
│   ├── DECISIONS.md
│   ├── CONTRACTS.md                 (opcional)
│   ├── archive/                     (auto-creada por /apex-tidy)
│   └── skills/                      ← Skills de Codex
│       ├── apex-start/
│       ├── apex-end/
│       ├── apex-sync/
│       ├── apex-tidy/
│       ├── apex-schema/
│       ├── apex-linear-bootstrap/
│       ├── apex-linear-sync/
│       └── apex-linear-add/
└── .claude/
    ├── commands/                    ← Slash commands de Claude Code
    │   ├── apex-init.md
    │   ├── apex-start.md
    │   ├── apex-end.md
    │   ├── apex-sync.md
    │   └── apex-tidy.md
    └── skills/
        └── apex-schema/             ← Auto-dispara con frases de BD
```

---

## Reglas operativas

- Corré `/apex-start` para empezar. No leas todos los archivos del cerebro de entrada.
- Para cualquier trabajo de BD, `apex-schema` lee `SCHEMA.md` antes de escribir.
- Una tarea no entra a Done sin `[PR: #N]` o `[@<short-sha>]`.
- Registrá decisiones una vez en `DECISIONS.md` — basta de re-debatirlas.
- Cuando cambia un contrato, actualizá `CONTRACTS.md` y avisale a los consumidores.
- Corré `/apex-tidy` semanalmente (o en un hook) — mantené el cerebro chico.

---

## Cómo se compara APEX

| | APEX | OpenAI Symphony | `CLAUDE.md` pelado |
| --- | --- | --- | --- |
| Infraestructura | Ninguna — markdown + bash | Servicio Elixir/OTP + dashboard | Ninguna |
| Fuente de verdad | TASKS.md o Linear (configurable) | Linear | El repo |
| Aislamiento | Worktrees (opcional) | Workspace por issue (built-in) | Ninguno |
| Proof of work | Gate de PR / commit-hash en `/apex-end` | PR + CI + comentarios resueltos + workpad | Ninguno |
| Multi-agente | Secuencial, file-locked | Paralelo, supervisado por servicio | N/A |
| Ideal para | Solo / equipos chicos / on-ramp | Equipos medianos-grandes corriendo flotas | Proyectos one-off |

APEX y Symphony no compiten — APEX es la **capa de harness** que Symphony asume que tenés. Si superás APEX, los archivos del cerebro portan directo: los estados de `TASKS.md` ya matchean la máquina de estados de Symphony.

---

## Ver la página de referencia

```sh
open index.html
# o
python3 -m http.server 8080
```

---

## Licencia

MIT.
