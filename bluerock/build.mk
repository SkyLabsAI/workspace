BHV_DIR = bluerock/bhv
GITLAB_URL="${GITHUB_URL}SkyLabsAI/bluerock."

.PHONY: ast-prepare-bhv
ast-prepare-bhv: ide-prepare
ifeq ($(wildcard ${BHV_DIR}),${BHV_DIR})
	@echo "[AST] ${BHV_DIR}"
	+$(Q)(LLVM=1 BUILD_CACHING=0 SHALLOW=1 \
		GITLAB_URL=${GITLAB_URL} \
		uv --directory ${BHV_DIR} run \
		   --python 3.13 \
		   --with-requirements python_requirements.txt \
		   --no-project --isolated -- ./fm-build.py -b)
else
	@echo "Skipping AST generation for ${BHV_DIR} (not cloned)."
endif

.PHONY: prepare-bhv-scaffold
prepare-bhv-scaffold:
ifeq ($(wildcard ${BHV_DIR}-scaffold),${BHV_DIR}-scaffold)
	@echo "[PREP] ${BHV_DIR}-scaffold"
	+$(Q)(LLVM=1 BUILD_CACHING=0 SHALLOW=1 CONF_MK=conf.fm.default.mk \
		GITLAB_URL=${GITLAB_URL} \
		uv --directory ${BHV_DIR}-scaffold run \
		   --python 3.13 \
		   --with-requirements python_requirements.txt \
		   --no-project --isolated -- $(MAKE) init)
	+$(Q)(LLVM=1 BUILD_CACHING=0 SHALLOW=1 CONF_MK=conf.fm.default.mk \
		GITLAB_URL=${GITLAB_URL} \
		uv --directory ${BHV_DIR}-scaffold run \
		   --python 3.13 \
		   --with-requirements python_requirements.txt \
		   --no-project --isolated -- bear -- $(MAKE))
else
	@echo "Skipping AST generation for ${BHV_DIR}-scaffold (not cloned)."
endif

NOVA_DIR = bluerock/NOVA

.PHONY: ast-prepare-NOVA
ast-prepare-NOVA: ide-prepare
ifeq ($(wildcard ${NOVA_DIR}),${NOVA_DIR})
	$(Q)$(MAKE) -C ${NOVA_DIR} CPP2V=$${PWD}/${CPP2V} dune-ast
else
	@echo "Skipping AST generation for ${NOVA_DIR} (not cloned)."
endif

.PHONY: ast-prepare-bluerock
ast-prepare-bluerock: ast-prepare-bhv ast-prepare-NOVA

.PHONY: clean-bluerock
clean-bluerock: clean-bhv clean-bhv-scaffold clean-NOVA

.PHONY: clean-bhv
clean-bhv:
ifeq ($(wildcard ${BHV_DIR}),${BHV_DIR})
	$(Q)$(MAKE) -C ${BHV_DIR} clean
endif

.PHONY: clean-bhv-scaffold
clean-bhv-scaffold:
ifeq ($(wildcard ${BHV_DIR}-scaffold),${BHV_DIR}-scaffold)
	$(Q)$(MAKE) -C ${BHV_DIR}-scaffold clean
endif

.PHONY: clean-NOVA
clean-NOVA:
ifeq ($(wildcard ${NOVA_DIR}),${NOVA_DIR})
	$(Q)$(MAKE) -C ${NOVA_DIR} clean
endif
