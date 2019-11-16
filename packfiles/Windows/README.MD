# Windows AMIS

You can find the latest windows ami using (assuming you're after 2012 r2):

```AWS
$Windows=(aws ec2 describe-images --owners self amazon --filters --filters "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64" "Name=platform,Values=windows" "Name=name,Values='Windows_Server-2012-R2_RTM-English-64Bit-Base*'|convertfrom-json).Images|sort Name| Select-Object -Last 1
```

But it's easier to use a source AMI filter:

~~~ packer
"source_ami_filter":
{
    "filters": {
        "virtualization-type": "hvm",
        "name": "Windows_Server-2012-R2_RTM-English-64Bit-Base*",
        "root-device-type": "ebs"
        },
        "owners": [
            "self",
            "amazon"
            ],
            "most_recent": true
}
~~~
