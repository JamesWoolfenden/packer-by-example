#Makefile
PACKFILE ?= "packfiles/base.json"
ENVIRONMENT ?= "environment/<env>.json"

.PHONY: base

base:
	sh ./build.sh -p ${PACKFILE} -e ${ENVIRONMENT}
