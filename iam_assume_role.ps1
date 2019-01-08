Param(
  [Parameter(Mandatory=$true)]
  [string]$AccountNo,
  [Parameter(Mandatory=$true)]
  [string]$Role,
  [string]$SESSION_NAME = "PACKER"
)


function iam_assume_role
{
   Param(
     [Parameter(Mandatory=$true)]
     [string]$AccountNo,
     [Parameter(Mandatory=$true)]
     [string]$Role
   )

   write-host "AccountNo: $AccountNo"
   write-host "Role     : $Role"

   $ARN="arn:aws:iam::$($AccountNo):role/$Role"
   Write-Host "ARN      : $ARN"
   write-host "aws sts assume-role --role-arn $ARN --role-session-name $SESSION_NAME --duration-seconds 3600"
   $Creds=aws sts assume-role --role-arn $ARN --role-session-name $SESSION_NAME --duration-seconds 3600 |convertfrom-json

   [Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION","eu-west-2")
   [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID",$creds.Credentials.AccessKeyId)
   [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY",$creds.Credentials.AccessKeyId)
   [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY",$creds.Credentials.SecretAccessKey)
   [Environment]::SetEnvironmentVariable("AWS_SECRET_KEY", $creds.Credentials.SecretAccessKey)
   [Environment]::SetEnvironmentVariable("AWS_SESSION_TOKEN",$creds.Credentials.SessionToken)
}

iam_assume_role -AccountNo $AccountNo -Role $Role
