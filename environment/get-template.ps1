[string]$accountid
[string]$templatename
[string]$vpc
[string]$basetemplate="template-aws"
[string]$subnet

$vpc=aws ec2 describe-vpcs  --output text --query 'Vpcs[0].{VpcId:VpcId}'
$subnet=aws ec2 describe-subnets --output text --query 'Subnets[0].{SubnetId:SubnetId}'
$accountid=aws sts get-caller-identity --output text --query 'Account'
$templatename=aws iam list-account-aliases --output text --query 'AccountAliases'
$envtemplate=get-content .\$basetemplate.json|convertfrom-json
$envtemplate.ami_users=$accountid
$envtemplate.vpc_id=$vpc
$envtemplate.subnet_id=$subnet
$envtemplate.aws_region=aws configure get region
$envtemplate|ConvertTo-Json| Set-Content -Path ".\$templatename.json"
