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

## Profling
In the default dune profile (`sl_timing`), any file built through dune records
profiling spans in the corresponding .glob file that is created in
`_build/default`. The following command extracts the data.

```bash
dune exec -- globfs extract _build/default/<full file path without suffix>.glob
```

This creates `<file>.glob.*` files, of which two are relevant for profiling:
1. `<file>.glob.log.json` containing logging spans with profiling data.
   This is fine-grained data that can be used to identify changes in the
   automation and even in individual hints.
2. `<file>.glob.perf.json` containing Rocq's performance spans.
   This is Vernacular-level profiling data about Rocq commands and tactics.

Individual tactics can be profiled using `with_log_file "/tmp/<name>.json"`.
To profile top-level commands or entire sections of files, enclose them with
```rocq
Ltac2 Eval logger.Log.reset_log ().
…
Ltac2 Eval logger.Log.output_log_file "/tmp/<name>.json".
```

The logger reports warnings with the default log levels (`0`) which can be
ignored. It will still emit spans that contain the profiling data.

Fine-grained profiling data generated this way or found in `.glob.log.json` files
can be converted to `perf script`-like output via

```bash
dune exec -- rocq-perf.perf-script /path/to/file.json > output.script
```

## Scope

This top-level `AGENTS.md` is workspace-wide guidance. Nested `AGENTS.md` files
belong to the repository or package subtree that contains them and may add more
specific rules for that subtree.
