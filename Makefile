#Makefile
PACKFILE ?= "packfiles/base.json"
ENVIRONMENT ?= "environment/<env>.json"

.PHONY: base validate

base:
	sh ./build.sh -p ${PACKFILE} -e ${ENVIRONMENT}

validate:
	@echo "Validating Packer templates..."
	@find packfiles -name "*.json" -type f -exec packer validate -syntax-only {} \; || true
	@for dir in hcl2/*/; do \
		if [ -f "$${dir}"*.pkr.hcl ]; then \
			echo "Validating $${dir}"; \
			cd "$${dir}" && packer validate . || true; \
			cd - > /dev/null; \
		fi \
	done
	@echo "Validation completed"
