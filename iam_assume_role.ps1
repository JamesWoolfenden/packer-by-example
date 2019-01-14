<#
.SYNOPSIS
    A wrapper script for Assuming different AWS roles, useful for roles and specifically cross account roles.
.DESCRIPTION
    Wraps up support for AWS role support
.PARAMETER Path
    The path to the .
.EXAMPLE
    C:\PS>.\code\bumsonseats\iam_assume_role.ps1 -AccountNo 12121212121 -Role MarcusDogsbody
.NOTES
    Author: James Woolfenden
    Date:   January 10, 2019
#>

Param(
  [Parameter(Mandatory=$true)]
  [string]$AccountNo,
  [Parameter(Mandatory=$true)]
  [string]$Role,
  [string]$SESSION_NAME = "PACKER"
)


function iam_assume_role
{
  <#
  .Description
  iam_assume_role allows you to run as a different role in a different account

  .Example
   iam_assume_role -AccountNo $AccountNo -Role SuperAdmin
#>
   Param(
     [Parameter(Mandatory=$true)]
     [string]$AccountNo,
     [Parameter(Mandatory=$true)]
     [string]$Role
   )

   Write-Output "AccountNo: $AccountNo"
   Write-Output "Role     : $Role"

   $ARN="arn:aws:iam::$($AccountNo):role/$Role"
   Write-Output "ARN      : $ARN"
   Write-Output "aws sts assume-role --role-arn $ARN --role-session-name $SESSION_NAME --duration-seconds 3600"
   $Creds=aws sts assume-role --role-arn $ARN --role-session-name $SESSION_NAME --duration-seconds 3600 |convertfrom-json

   [Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION","eu-west-2")
   [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID",$creds.Credentials.AccessKeyId)
   [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY",$creds.Credentials.AccessKeyId)
   [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY",$creds.Credentials.SecretAccessKey)
   [Environment]::SetEnvironmentVariable("AWS_SECRET_KEY", $creds.Credentials.SecretAccessKey)
   [Environment]::SetEnvironmentVariable("AWS_SESSION_TOKEN",$creds.Credentials.SessionToken)
}

iam_assume_role -AccountNo $AccountNo -Role $Role
