<#
.SYNOPSIS
    A wrapper script for Packer
.DESCRIPTION
    Wraps up Packer with support for environment files and Packer Debug flags
.PARAMETER Path
    The path to the .
.EXAMPLE
    C:\PS>build.ps1 -packfile .\packfiles\redhat\base.json -environment .\environmment\jameswoolfenden-sandbox.json
.NOTES
    Author: James Woolfenden
    Date:   January 10, 2019
#>

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
   Invoke-Packer -packfile .\packfiles\redhat\base.json -environment .\environmment\jameswoolfenden-sandbox.json
#>

param(
  [Parameter(Mandatory=$true)]
  [string]$packfile,
  [Parameter(Mandatory=$true)]
  [string]$environment)

   Write-Output "Checking $environment Found: $(test-path $environment)"
   Write-Output "Checking $packfile Found: $(test-path $packfile)"

   packer validate -var-file="$environment" $packfile
   packer build -var-file="$environment" $packfile
}

Invoke-Packer -packfile $packfile -environment $environment
