# Workspace Agent Guide

This repository is the SkyLabs AI `workspace`: a composed checkout assembled
from separate repositories using our replacement for `git submodules`.

Nested repositories under `fmdeps/`, `vendored/`, and `bluerock/`
remain independently meaningful projects. Many contain multiple OPAM packages
that can be installed and used outside this workspace, and release Docker
images install those packages separately. Inside this checkout, however, the
intended development model is the composed workspace build.

## Build Rules

- Run Dune commands from the workspace root unless a task explicitly targets an
  independently installed package outside this workspace.
- Do not use `dune --root` as a workaround for build or dependency failures in
  this checkout. It changes the build to an isolated project model and makes
  Dune resolve dependencies as installed packages, which is not the workspace
  development model.
- If a composed build reports a missing tool or dependency, fix or report that
  environment issue instead of switching roots.
- For Rocq `.v` edit loops, prefer `rocq-ed`: `rocq-ed init` builds
  dependencies by default, and `--no-build-deps` is only an explicit opt-out
  when dependencies are known to be current. Use composed Dune builds from the
  workspace root for final validation.
- For Rocq output tests, use Dune's built-in `.v` plus `.expected` support
  instead of custom diff rules.

## Matching Rocq CI

To check that the entire Rocq codebase builds, you have two options:
1. Open new PRs or push to existing ones will create new CI pipelines.
2. On machines with enough resources, you can check locally with:

    make -j$(nproc) stage1
    dune b @vendored/install @fmdeps/all @fmdeps/runtest @bluerock/bhv/proof @bluerock/NOVA/all

Run this through `direnv` (this repo ships an `.envrc`) so the toolchain on
`PATH` matches the workspace.

Option 2 might be faster on beefy enough machines, especially servers. In
doubt, confirm with the user.

## Attribution of Agent-Written Text

*This section was written by Codex (AI agent).*

- Clearly attribute all agent-written prose that you publish or commit,
  including pull request descriptions, issue bodies, review comments, commit
  messages, documentation, and explanatory source comments.
- Put the attribution in the text itself, for example:
  `Written by Codex (AI agent).` Do not rely solely on the Git author or the
  account posting it.
- Name the agent and, when known, its model and reasoning effort. Do not guess
  model information that is unavailable.
- Preserve attribution when copying or adapting agent-written text. For mixed
  human and agent contributions, identify the agent's contribution accurately;
  use wording such as `Edited with Codex (AI agent).` where appropriate.

## Scope

This top-level `AGENTS.md` is workspace-wide guidance. Nested `AGENTS.md` files
belong to the repository or package subtree that contains them and may add more
specific rules for that subtree.
