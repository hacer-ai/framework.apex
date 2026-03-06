#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/templates/shared-brain"

usage() {
  cat <<'EOF'
Usage: scripts/install-apex.sh [target-dir] [--project-name NAME] [--force]

Installs the APEX shared-brain scaffold into a project.

Examples:
  scripts/install-apex.sh .
  scripts/install-apex.sh ../my-app --project-name "My App"
  scripts/install-apex.sh . --force
EOF
}

TARGET_DIR="."
PROJECT_NAME=""
FORCE=false

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

# User-owned entry-point files — never overwritten.
USER_FILES=(
  "AGENTS.md"
  "CLAUDE.md"
)

# Framework files — safe to overwrite with --force.
FILES=(
  ".agents/CONTEXT.md"
  ".agents/MAP.md"
  ".agents/SCHEMA.md"
  ".agents/TASKS.md"
  ".agents/PROGRESS.md"
  ".agents/DECISIONS.md"
  ".agents/CONTRACTS.md"
  ".agents/playbooks/init.md"
  ".agents/playbooks/start-session.md"
  ".agents/playbooks/end-session.md"
  ".agents/playbooks/db-change.md"
  ".agents/playbooks/plan-feature.md"
  ".agents/playbooks/onboard.md"
  ".claude/commands/apex-init.md"
  ".claude/commands/apex-start.md"
  ".claude/commands/apex-end.md"
  ".claude/commands/apex-schema.md"
  ".claude/commands/apex-plan.md"
  ".claude/commands/apex-onboard.md"
)

for file in "${USER_FILES[@]}"; do
  copy_user_file "$file"
done

for file in "${FILES[@]}"; do
  copy_file "$file"
done

printf '\nInstalled APEX shared-brain scaffold into %s\n' "$(cd "$TARGET_DIR" && pwd)"
printf 'Next steps:\n'
printf '1. Open Claude Code in the project and run: /apex-init\n'
printf '   Claude will read the codebase and fill in .agents/ automatically.\n'
printf '2. Review and correct the generated files.\n'
printf '3. Run /apex-start to begin the first work session.\n'
