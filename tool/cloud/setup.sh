#!/bin/bash
# Setup script for Yumdoor's Claude Code cloud environment (tool/cloud/README.md).
#
#   bash tool/cloud/setup.sh [flutter-version]
#
# Installs the Flutter SDK to /opt/flutter (flutter and dart in /usr/local/bin)
# and pulls the local Tandoor's Docker images. Without a version it reads the
# pinned versions from main on GitHub, because the environment's setup script
# can run before the repository is cloned. Linux-only, so Bash rather than Dart:
# it runs before Dart exists. Always exits 0; session_start.sh retries Flutter.
set -uo pipefail

repo_raw="https://raw.githubusercontent.com/dan-grm/yumdoor/main"
flutter_version="${1:-$(curl -fsSL "$repo_raw/pubspec.yaml" | sed -n '/^environment:/,/^[^ ]/s/^  flutter: *//p')}"

# Chained with && because set -e doesn't apply inside `install_flutter || …`.
install_flutter() {
  local url="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${flutter_version}-stable.tar.xz"
  rm -rf /opt/flutter &&
    curl -fsSL "$url" | tar -xJ -C /opt &&
    git config --global --add safe.directory /opt/flutter &&
    ln -sf /opt/flutter/bin/flutter /opt/flutter/bin/dart /usr/local/bin/ &&
    flutter config --no-analytics --no-cli-animations >/dev/null &&
    dart --disable-analytics >/dev/null &&
    flutter precache --web &&
    flutter --version
}

pull_tandoor_images() {
  if ! docker info >/dev/null 2>&1; then
    (dockerd >/var/log/dockerd.log 2>&1 &)
    for _ in $(seq 30); do docker info >/dev/null 2>&1 && break; sleep 1; done
  fi
  local tandoor
  tandoor="$(curl -fsSL "$repo_raw/TANDOOR_VERSION" | tr -d '[:space:]')"
  docker pull postgres:16-alpine
  docker pull "vabene1111/recipes:$tandoor"
}

# Only when called without a version: session_start.sh passes one and needs
# just Flutter.
if [[ $# -eq 0 ]]; then
  pull_tandoor_images >/tmp/tandoor-images.log 2>&1 &
fi
install_flutter || echo "Flutter $flutter_version was not installed; session_start.sh will retry." >&2
wait
exit 0
