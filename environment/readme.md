# Environment Folder

The property files here are to populate the packer variables for environment.
The file template.json is an example file.

## To populate the environment files

## For AWS

`aws ec2 describe-vpcs`

`aws ec2 describe-subnets`

`aws sts get-caller-identity --output text --query 'Account'`

How do i find the AMI's on which to base my work:
(<https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/>)

In Powershell

```powershell
aws ec2 describe-images --filter Name="name",Values="CentOS7*"|convertfrom-json
aws ec2 describe-images --filter Name="ProductCode",Values="aw0evgkw8e5c1q413zgy5pjce"|convertfrom-json
```

In Bash

```Bash
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

To run to make environment file.

In Powershell

```Powershell
.\write-environmentFile.ps1 -BaseName template
```

In Bash

```Bash
.\write-environmentFile.sh template
```
