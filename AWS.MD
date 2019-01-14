# AWS amis

These examples target the customisation of existing AWS Amis, usually from AWS or from trusted sources such as Canonicals AWS account. You can find the details of an AMI from the command line

## AWS Set-up

You will need to set-up and configured your AWS:

```cli
aws configure
```

When you run packer its is assumed that the following Environment variables are set:

```cli
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

You can run

```bash
./build.sh -packfile ./packfiles/redhat/base-aws.json -environment
```

Additionally in the root you will find the script **iam_assum_role**, this allows you to assume an aws role to build your AMI's.
