# Use "make ... Q=" to show more commands.
Q=@

# Pick default bash on MacOS, even if it's installed with Homebrew.
SHELL := $(shell which bash)

DUNE_WRAPPER := dev/dune-tools/dune-named-logfile/dune-named-logfile

.PHONY: all
all: _CoqProject stage1
	$(Q)dune build --display=short

CPP2V = _build/install/default/bin/cpp2v
.PHONY: ide-prepare
ide-prepare: _CoqProject
	$(Q)$(DUNE_WRAPPER) build --display=short @vendored/rocq/install ${CPP2V}

.PHONY: FORCE
FORCE:

_CoqProject: fmdeps/BRiCk/scripts/coq_project_gen/gen-_CoqProject-dune.sh FORCE
	$(Q)$< > $@ || { rm -f $@; exit 1; }

.PHONY: stage1
stage1: ide-prepare ast-prepare-bluerock

# Explicitly avoid installing fm-tools since doing so can break
# dune. It is not obvious that we should install BRiCk and auto.
.PHONY: pipeline-deps
pipeline-deps:
	$(Q)dune build @vendored/install @fmdeps/rocq-agent-toolkit/install @fmdeps/BRiCk/install @fmdeps/auto/install

# Include the rules for development tools (deps checking, ...)
include dev/rules.mk

# Include the rules for managing the workspace and sub-repositories.
include dev/repos/rules.mk

# AST generation of BlueRock repos.
include bluerock/build.mk

.PHONY: clean
clean: clean-bluerock
	$(Q)rm -rf $(GENERATED_FILES)
	$(Q)dune clean
