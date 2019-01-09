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
   .\build.ps1  -packfile .\packfiles\redhate\base.json -environment .\environmment\jameswoolfenden-sandbox.json
#>

param(
  [Parameter(Mandatory=$true)]
  [string]$packfile,
  [Parameter(Mandatory=$true)]
  [string]$environment)

   Write-host "Checking $environment Found: $(test-path $environment)"
   Write-host "Checking $packfile Found: $(test-path $packfile)"

   packer validate -var-file="$environment" $packfile
   packer build -var-file="$environment" $packfile
}

Invoke-Packer -packfile $packfile -environment $environment
