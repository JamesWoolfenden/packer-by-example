param(
  [Parameter(Mandatory=$true)]
  [string]$packfile,
  [Parameter(Mandatory=$true)]
  [string]$environment)

function Invoke-Packer
{
<#
  .Description
  Get-Function displays the name and syntax of all functions in the session.

  .Example
   .\build.ps1  -packfile .\consul-vault.json -environment jameswoolfenden-sandbox
#>

param(
  [Parameter(Mandatory=$true)]
  [string]$packfile,
  [Parameter(Mandatory=$true)]
  [string]$environment)

   Write-host "Checking .\environment\$environment.json Found: $(test-path .\environment\$environment.json)"
   Write-host "Checking .\packfiles\$packfile Found: $(test-path .\packfiles\$packfile)"

   packer validate -var-file=".\environment\$environment.json" .\packfiles\$packfile
   packer build -var-file=".\environment\$environment.json" .\packfiles\$packfile
}

Invoke-Packer -packfile $packfile -environment $environment
