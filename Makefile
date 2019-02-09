SHELL := /bin/bash

AWS_DEFAULT_REGION ?= "eu-west-1"
PACKFILE ?= "packfiles/RedHat/base-aws.json"
ENVIRONMENT ?= "environment/personal-jgw.json"

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/JamesWoolfenden/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

## Lint terraform code
lint:	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate

## test
validate:
	packer validate -var-file="./environment/slalom-azure.json" ./packfiles/Ubuntu/base-azure.json
