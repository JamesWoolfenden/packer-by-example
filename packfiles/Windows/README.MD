You can find the lastest windows ami using (assuming you'e after 2012 r2):

~~~
$Windows=(aws ec2 describe-images --owners self amazon --filters --filters "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64" "Name=platform,Values=windows" "Name=name,Values='Windows_Server-2012-R2_RTM-English-64Bit-Base*'|convertfrom-json).Images|sort Name| Select-Object -Last 1
~~~
