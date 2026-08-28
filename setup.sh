#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$ROOT_DIR/skills"
MANIFEST_NAME=".claude-hunter-managed"

usage() {
    cat <<'EOF'
Usage:
  ./setup.sh --install claude
  ./setup.sh --remove claude
  ./setup.sh --install codex
  ./setup.sh --remove codex
EOF
}

target_dir() {
    case "$1" in
        claude) printf '%s\n' "${HOME}/.claude/skills" ;;
        codex) printf '%s\n' "${HOME}/.codex/skills" ;;
        *) echo "Unknown target: $1" >&2; usage >&2; exit 2 ;;
    esac
}

skill_names() {
    find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print \
        | while IFS= read -r path; do basename "$path"; done \
        | sort
}

install_skills() {
    local target="$1"
    local destination
    destination="$(target_dir "$target")"
    mkdir -p "$destination"

    while IFS= read -r name; do
        if [[ "$name" == .* ]]; then
            continue
        fi
        if [[ -e "$destination/$name" || -L "$destination/$name" ]]; then
            echo "Refusing to overwrite existing skill: $destination/$name" >&2
            echo "Remove it manually or choose a different installation target." >&2
            exit 1
        fi
        cp -R "$SKILLS_DIR/$name" "$destination/$name"
    done < <(skill_names)

    printf '%s\n' "$(skill_names)" > "$destination/$MANIFEST_NAME"
    echo "Installed skills for $target in $destination"
}

remove_skills() {
    local target="$1"
    local destination manifest name
    destination="$(target_dir "$target")"
    manifest="$destination/$MANIFEST_NAME"

    if [[ ! -f "$manifest" ]]; then
        echo "No managed installation found for $target at $destination"
        return 0
    fi

    while IFS= read -r name; do
        [[ -n "$name" ]] || continue
        case "$name" in
            *[!a-z0-9-]*)
                echo "Invalid managed skill name in manifest: $name" >&2
                exit 1
                ;;
        esac
        if [[ -d "$destination/$name" || -L "$destination/$name" ]]; then
            rm -rf "$destination/$name"
        fi
    done < "$manifest"

    rm -f "$manifest"
    echo "Removed managed skills for $target from $destination"
}

if [[ $# -ne 2 ]]; then
    usage >&2
    exit 2
fi

command="$1"
target="$2"

[[ -d "$SKILLS_DIR" ]] || { echo "Skills directory not found: $SKILLS_DIR" >&2; exit 1; }

case "$command" in
    --install) install_skills "$target" ;;
    --remove) remove_skills "$target" ;;
    *) usage >&2; exit 2 ;;
esac
