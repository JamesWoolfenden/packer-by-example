#!/bin/bash
set -e

usage(){
  echo "Usage: $0 -p packfile -e environment -d false"
  exit 1
}

if [ "$#" -lt 4 ]; then
    usage;
  fi

while getopts p:e:d: option
do
 case "${option}"
 in
 p) packfile=${OPTARG};;
 e) environment=${OPTARG};;
 d) debug=${6:-false};;
 -h|--help) usage
            exit ;;
  --) shift
      break ;;
  *) usage ;;
 esac
done

#example
# .\build.sh -environment sandbox -packfile consul-vault
echo "packfile:    $packfile"
echo "environment: $environment"

packer validate -var-file="./environment/${environment}.json" "./packfiles/${packfile}"
if [ "$debug" = "true" ]; then
    packer build -debug -on-error=ask -var-file="./environment/${environment}.json" "./packfiles/${packfile}"
else
    packer build  -var-file="./environment/${environment}.json" "./packfiles/${packfile}"
fi
