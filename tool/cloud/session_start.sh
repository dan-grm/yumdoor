#!/bin/bash
# SessionStart hook (.claude/settings.json). In a Claude Code cloud session it
# makes sure the Flutter version pinned in pubspec.yaml is installed and the
# packages are fetched. Anywhere else it does nothing.
set -euo pipefail

[[ "${CLAUDE_CODE_REMOTE:-}" == "true" ]] || exit 0
cd "$CLAUDE_PROJECT_DIR"

pinned="$(sed -n '/^environment:/,/^[^ ]/s/^  flutter: *//p' pubspec.yaml)"
installed="$( (flutter --version --machine 2>/dev/null || true) |
  sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')"
if [[ "$pinned" != "$installed" ]]; then
  echo "Installing Flutter $pinned (found '${installed:-none}')." >&2
  bash tool/cloud/setup.sh "$pinned" >&2
fi

flutter pub get >&2
