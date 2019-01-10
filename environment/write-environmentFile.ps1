<#
.SYNOPSIS
    Creates an environment file for use with Packer packfiles
.DESCRIPTION
    The Packer files in the packfiles folder expect certain variables to come from and environment file.
    This script is designed to create theese for you.
.PARAMETER Path
    The path to the .
.EXAMPLE
    C:\PS>get-environment.ps1
    This script runs without prompt or parameters
.NOTES
    Author: James Woolfenden
    Date:   January 10, 2019
#>
Param(
    [string]$basetemplate="template-aws")

#locally defined and used
[string]$accountid
[string]$templatename
[string]$vpc
[string]$subnet

$vpc=aws ec2 describe-vpcs  --output text --query 'Vpcs[0].{VpcId:VpcId}'
$subnet=aws ec2 describe-subnets --output text --query 'Subnets[0].{SubnetId:SubnetId}'
$accountid=aws sts get-caller-identity --output text --query 'Account'

Write-Host "$(get-date) - Talking to AWS account $accountid"
$templatename=aws iam list-account-aliases --output text --query 'AccountAliases'

write-host "$(get-date) - imported template .\$basetemplate.json"
$envtemplate=get-content .\$basetemplate.json|convertfrom-json
$envtemplate.ami_users=$accountid
$envtemplate.vpc_id=$vpc
$envtemplate.subnet_id=$subnet
$envtemplate.aws_region=aws configure get region
$envtemplate|ConvertTo-Json| Set-Content -Path ".\$templatename.json"

Write-Host "$(get-date) - written .\$templatename.json"
