#Makefile
AWS_DEFAULT_REGION ?= "eu-west-1"
PACKFILE ?= "base.json"
ENVIRONMENT ?= "management-<account-number>"

.PHONY: base

base:
	sh ./build.sh -p ${PACKFILE} -e ${ENVIRONMENT}
