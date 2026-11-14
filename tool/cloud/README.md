# Claude Code cloud sessions

Yumdoor can be developed in [Claude Code cloud sessions](https://code.claude.com/docs/en/claude-code-on-the-web):
an Anthropic-hosted Ubuntu VM that clones the repository and keeps working while your computer is off. Start them
at [claude.ai/code](https://claude.ai/code) or in the Code tab of the Claude app, then use the project skills as
usual (`/milestone run`, `/ship 51`, `/ship <bug description>`).

## One-time setup

1. **GitHub access:** install the [Claude GitHub App](https://github.com/apps/claude) on `dan-grm/yumdoor`. That
   also allows auto-fix of PRs.
2. **Environment:** at claude.ai/code, add an environment (or edit **Default**):
   - **Network access:** Limited, with **Allow package managers** checked. The default allowlist covers
     everything Yumdoor needs (GitHub, Flutter downloads, pub.dev, Docker Hub).
   - **Setup script:** paste the contents of [`setup.sh`](setup.sh). It installs Flutter and pulls the Tandoor
     images; the result is cached, so later sessions start in seconds.
   - **Environment variables:** none. Don't add a `GH_TOKEN`; GitHub access goes through Anthropic's proxy.
3. **Check it:** in the first session, ask Claude to run `flutter --version` and
   `flutter test --exclude-tags integration`, start the local Tandoor, seed it and run the integration tests. If
   something fails, fix the scripts here in a PR.

## What happens in a session

- The setup script ran once and was snapshotted (the snapshot is rebuilt about weekly, or when you edit the
  script). It reads the pinned Flutter and Tandoor versions from `main`.
- [`session_start.sh`](session_start.sh) runs on every session start (a hook in `.claude/settings.json`). It
  installs the Flutter version pinned in `pubspec.yaml` if the cached one differs, for example on a branch that
  bumps Flutter, and runs `flutter pub get`. Locally it does nothing.
- Claude starts the local Tandoor with Docker when a task needs it.
- GitHub works only through `gh api` (REST): cloud sessions block GraphQL, and with it `gh pr` and `gh issue`. The
  skills account for that.
- Goldens can be rendered in the session itself (Linux, like CI).

## Limits

- The VM has 4 vCPUs, 16 GB RAM and 30 GB disk.
- Cloud sessions count toward the plan's usage limits.
- A session waiting a long time for an answer can expire. Reopening it keeps the conversation; restart anything that
  was running, such as Tandoor.
