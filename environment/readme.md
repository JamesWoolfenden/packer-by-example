# Environment Folder

The property files here are to populate the packer variables for environment
The file template.json is an example file.

## To populate the environment files

## For AWS

`aws ec2 describe-vpcs`

`aws ec2 describe-subnets`

`aws sts get-caller-identity --output text --query 'Account'`

```cli
$images=aws ec2 describe-images --filter Name="name",Values="CentOS7*"|convertfrom-json
$images=aws ec2 describe-images --filter Name="ProductCode",Values="aw0evgkw8e5c1q413zgy5pjce"|convertfrom-json

aws ec2 describe-images \
 --owners 679593333241 \
 --filters \
 Name=name,Values='CentOS Linux 7 x86_64 HVM EBS\*' \
 Name=architecture,Values=x86_64 \
 Name=root-device-type,Values=ebs \
 --query 'sort_by(Images, &Name)[-1].ImageId' \
 --output text
```

## Automated Method

### Powershell

To run to make environment file.

```Powershell
.\write-environmentFile.ps1 -BaseName template
```
