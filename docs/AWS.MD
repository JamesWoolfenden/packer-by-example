# AWS AMI

These examples target the customisation of existing AWS AMI's, usually from AWS or from trusted sources such as Canonicals AWS account. You can find the details of an AMI from the command line.

## AWS Set-up

You will need to set-up and configured your AWS with the AWS **configure** command:

```cli
$aws configure
AWS Access Key ID [********************]:
AWS Secret Access Key [*******************]:
Default region name [eu-west-1]:
Default output format [json]:
```

Packer respects the AWS Authentication chain, so it will check your default profile and if not set it look for environment variables.
These are Environment variables it looks for:

```cli
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

A simple test of your auth set-up is see what S3 buckets you can list:

```cli
aws s3 ls
```

With the Authentication confirmed it's time to run Packer, I have to chosen to use a wrapper script and it assumes you call it from the root of this repository:

```bash
./build.sh -packfile ./packfiles/redhat/base-aws.json -environment
```

Additionally in the root you will find the script **iam_assum_role**, this allows you to assume an aws role to build your AMI's.
