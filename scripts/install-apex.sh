#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/templates/shared-brain"

usage() {
  cat <<'EOF'
Usage: scripts/install-apex.sh [target-dir] [--project-name NAME] [--linear] [--force]

Installs the APEX shared-brain scaffold into a project.

Options:
  --project-name NAME   Set the project name (default: directory name)
  --linear              Print step-by-step Linear MCP setup instructions
  --force               Overwrite existing framework files (never touches CLAUDE.md or AGENTS.md)

Examples:
  scripts/install-apex.sh .
  scripts/install-apex.sh ../my-app --project-name "My App"
  scripts/install-apex.sh . --linear
  scripts/install-apex.sh . --force
EOF
}

TARGET_DIR="."
PROJECT_NAME=""
FORCE=false
SETUP_LINEAR=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-name)
      PROJECT_NAME="${2:-}"
      if [[ -z "$PROJECT_NAME" ]]; then
        printf 'error: --project-name requires a value\n' >&2
        exit 1
      fi
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --linear)
      SETUP_LINEAR=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

mkdir -p "$TARGET_DIR"

if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME="$(basename "$(cd "$TARGET_DIR" && pwd)")"
fi

escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

PROJECT_NAME_ESCAPED="$(escape_sed "$PROJECT_NAME")"

# Copy a user-owned file: only create if missing, never overwrite (even with --force).
copy_user_file() {
  local rel="$1"
  local src="$TEMPLATE_DIR/$rel"
  local dst="$TARGET_DIR/$rel"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" ]]; then
    printf 'skip  %s (already exists — not overwritten)\n' "$rel"
    return
  fi

  sed "s/__PROJECT_NAME__/$PROJECT_NAME_ESCAPED/g" "$src" > "$dst"
  printf 'write %s\n' "$rel"
}

# Copy a framework file: skip if exists, overwrite only when --force is set.
copy_file() {
  local rel="$1"
  local src="$TEMPLATE_DIR/$rel"
  local dst="$TARGET_DIR/$rel"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && "$FORCE" != true ]]; then
    printf 'skip  %s (already exists)\n' "$rel"
    return
  fi

  sed "s/__PROJECT_NAME__/$PROJECT_NAME_ESCAPED/g" "$src" > "$dst"
  printf 'write %s\n' "$rel"
}

# ── User-owned files — created once, never overwritten (even with --force) ────
USER_FILES=(
  "AGENTS.md"
  "CLAUDE.md"

  # Brain files contain project-specific data that the user maintains.
  # Created on first install with starter templates, then owned by the project.
  ".agents/CONTEXT.md"
  ".agents/MAP.md"
  ".agents/SCHEMA.md"
  ".agents/TASKS.md"
  ".agents/PROGRESS.md"
  ".agents/DECISIONS.md"
  ".agents/CONTRACTS.md"
)

# ── Framework files — safe to overwrite with --force ──────────────────────────
FILES=(
  # Claude Code slash commands
  ".claude/commands/apex-init.md"
  ".claude/commands/apex-start.md"
  ".claude/commands/apex-task.md"
  ".claude/commands/apex-end.md"
  ".claude/commands/apex-ship.md"
  ".claude/commands/apex-review.md"
  ".claude/commands/apex-schema.md"
  ".claude/commands/apex-plan.md"
  ".claude/commands/apex-onboard.md"

  # Claude Code auto-invocation skill (fires on DB phrases without manual command)
  ".claude/skills/apex-schema/SKILL.md"

  # Codex skills (same content, different directory)
  ".agents/skills/apex-start/SKILL.md"
  ".agents/skills/apex-end/SKILL.md"
  ".agents/skills/apex-ship/SKILL.md"
  ".agents/skills/apex-review/SKILL.md"
  ".agents/skills/apex-schema/SKILL.md"
  ".agents/skills/apex-plan/SKILL.md"
  ".agents/skills/apex-linear-bootstrap/SKILL.md"
  ".agents/skills/apex-linear-bootstrap/agents/openai.yaml"
  ".agents/skills/apex-linear-sync/SKILL.md"
  ".agents/skills/apex-linear-sync/agents/openai.yaml"
  ".agents/skills/apex-linear-add/SKILL.md"
  ".agents/skills/apex-linear-add/agents/openai.yaml"
)

for file in "${USER_FILES[@]}"; do
  copy_user_file "$file"
done

for file in "${FILES[@]}"; do
  copy_file "$file"
done

printf '\nInstalled APEX shared-brain scaffold into %s\n' "$(cd "$TARGET_DIR" && pwd)"

# ── Linear MCP setup instructions ─────────────────────────────────────────────
if [[ "$SETUP_LINEAR" == true ]]; then
  cat <<'LINEAR_EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  LINEAR MCP SETUP — Follow these steps in order
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 1 — Register the Linear MCP server with Claude Code (run once per machine):

  claude mcp add-json linear '{"command":"npx","args":["-y","mcp-remote","https://mcp.linear.app/sse"]}'

Step 2 — Authenticate with Linear (run inside a Claude Code session):

  /mcp
  → Follow the OAuth flow. Log in with your Linear account.
  → You only do this once — auth persists across projects.

Step 3 — Verify the connection (ask Claude inside a session):

  "List my assigned Linear issues"
  → If you see your issues, you're connected.

Step 4 — Add your Linear Team ID and Project to .agents/CONTEXT.md:

  Under "External Services", add:
  | Linear | Issue tracking | MCP (OAuth) — run /mcp to auth |
  | Linear Team ID | [your-team-id] | Settings → General in Linear |
  | Linear Project | [project-name] | The Linear project to sync with |

  To find your Team ID: Linear → Settings → General → copy the Team identifier (e.g. ENG)

Step 5 — Push existing tasks to Linear (run once in Claude Code):

  /apex-linear-bootstrap
  → Creates a Linear issue for every task in .agents/TASKS.md
  → Writes the Linear ID (e.g. [LIN: ENG-47]) back into each task line

After bootstrap, new tasks added with "add task: [description]" will automatically
create a Linear issue and write the ID back to TASKS.md.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Troubleshooting
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If SSE gives connection issues, try the HTTP transport instead:
  claude mcp add --transport http linear-server https://mcp.linear.app/mcp

If you use claude.ai already, you can connect via:
  claude.ai → Settings → Connectors → Linear (zero-config OAuth)

LINEAR_EOF
fi

# ── Next steps ─────────────────────────────────────────────────────────────────
printf 'Next steps:\n'
printf '1. Open Claude Code in the project and run: /apex-init\n'
printf '   Claude reads the codebase and fills .agents/ automatically.\n'
printf '2. Review the generated files and fill in any gaps.\n'
printf '3. Run /apex-start to begin the first work session.\n'
if [[ "$SETUP_LINEAR" != true ]]; then
  printf '\nTo set up Linear integration later:\n'
  printf '  ./scripts/install-apex.sh . --linear\n'
fi
