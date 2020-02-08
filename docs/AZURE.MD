# Azure Images

## Azure Set-up

(Some of the packerfiles are modified examples from the Packer Source code repository).

## Pre-requisites

Packer instructions here <https://www.packer.io/docs/builders/azure-setup.html>
Needs an Azure resource group and storage container to store the completed VHDs in. If you have multiple AZ subscriptions you also need to set the current Sub. Using the Az cli:

```cli
az account set --subscription xxxxxxxxxx-xxxx-xxxx-xxxxxxxxx
```

```cli
$LOCATION="uksouth"
$GROUPNAME="packer"

az group create --name $GROUPNAME --location $LOCATION
az storage account create --name packfiles --resource-group $GROUPNAME --location $LOCATION --sku Standard_LRS  --kind Storage
```

Auth comes from client_id and secret passed in as env variables, you will need to create a user to get the Auth.

```cli
az ad sp create-for-rbac -n "Packer" --role contributor \
                            --scopes /subscriptions/{SubID}
```

Then add these to your shell:

```bash
export ARM_CLIENT_SECRET="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
export ARM_CLIENT_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
export ARM_SUBSCRIPTION_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
export ARM_TENANT_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
```

or

```powershell
$env:ARM_CLIENT_SECRET="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
$env:ARM_CLIENT_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
$env:ARM_SUBSCRIPTION_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
$env:ARM_TENANT_ID="xxxxxx-xxxx-xxxx-xxxx-xxxxxxx"
```

The CentOS example additionally uses an ssh passwords and this needs to be preset.

```bash
export ARM_SSH_PASS="cent0$73"
```

```powershell
$env:ARM_SSH_PASS="cent0$73"
```

You can run

```bash
./build.sh -packfile ./packfiles/freeebsd/freebsd-azure.json -environment ./environment/template-azure.json
```

or

```powershell
.\build.ps1 -packfile .\packfiles\freebsd\freebsd-azure.json -environment .\environment\template-azure.json
```

## Where's my image

<https://docs.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer>
