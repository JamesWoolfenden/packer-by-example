# Packer by Example

[![Latest Release](https://img.shields.io/github/v/tag/JamesWoolfenden/packer-by-example.svg)](https://github.com/JamesWoolfenden/packer-by-example)

By [James Woolfenden](https://www.linkedin.com/in/jameswoolfenden/)

Packer-by-example is a collection of Scripts, Ansible, Makefiles and Packer files to help build images in the Public Cloud.
It's designed to work with CI/CD systems such as Travis CI, CircleCI and Jenkins, or even at your console.
There many different examples for different type of Linux and Windows.
---

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

## Introduction

### Install

Here's how to get started...

1. `git clone https://github.com/jameswoolfenden/packer-by-example.git` to pull down the repository

2. `./setup-packer.sh` to get the tool. Or `brew install packer` on MacOS or `cinst packer` on Windows.

### Usage

You can run packer directly or if it's HCL2, a folder, otherwise you can use the build wrapper scripts supplied.
To run:

```bash tab="*nix"
./build.sh -p ./packfiles/CentOS/base-aws.json  -e ./environment/personal-jgw.json
```

Or on Windows:

```bash tab="powershell"
 .\build.ps1 -packfile .\packfiles\CentOS\base-aws.json -environment .\environment\personal-jgw.json
```

The environment files hold variables and the packfiles are the packer **json** templates. I'd prefer not to need the variable files at all but some values must be supplied.

Packer can be used to make an AMI that is pre-built for EC2 with support for Cloudwatch Logs and Metrics:

<img src="https://gist.githubusercontent.com/JamesWoolfenden/aec6aa174646655fb0374be66b899327/raw/b4cc4244068fa95c9bf9ce432c2531b8c5f9acde/termtosvg_0_bpl_ol.svg?sanitize=true">

This Repository contains a number of other examples for using Packer, with software installed for different OS and CloudPlatforms, ready to be configured at launch time.

Instructions for setting up each authenticatiom for Cloud provider are here:

- [AWS](docs/AWS.MD)
- [GCP](docs/GCP.MD)
- [AZURE](docs/AZURE.MD)

There are examples for Windows and different Linux distributions, and different versions of each.
The "packfiles" have examples of using basic features of script or Ansible providers to configure your images, as well as a method for versioning the AMI's.

## **NEW HCL2**

Packer has started adding in support for HCL2, this means that Packer is starting to look and feel like Terraform. It's still very much a in beta.

I have included a working example in the HCL2 folder.

```CLI
 packer build ./hcl2/ubuntu/
```

With HCL2 You can separate out builders from the Provisioners.

## Troubleshooting

Packer is a tidy tool and to investigate failures you need to tell it not to be. Supply the Debug Flag and the tool will leave the unfinished image  behind and the SSH key to connect.

### Common issue: SSH is blocked

Some Environments lock down inbound and outbound SSH connections by blocking port 22, 3389.
Check you're not making your AMI'S in private subnet and waiting pointlessly.

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/packer-by-example/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/packer-by-example/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2023 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage] |

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
[github]: https://github.com/jameswoolfenden
[linkedin]: https://www.linkedin.com/in/jameswoolfenden/
[twitter]: https://twitter.com/jimwoolfenden
[share_twitter]: https://twitter.com/intent/tweet/?text=packer-by-example&url=https://github.com/JamesWoolfenden/packer-by-example
[share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=packer-by-example&url=https://github.com/JamesWoolfenden/packer-by-example
[share_reddit]: https://reddit.com/submit/?url=https://github.com/JamesWoolfenden/packer-by-example
[share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/JamesWoolfenden/packer-by-example
[share_email]: mailto:?subject=packer-by-example&body=https://github.com/JamesWoolfenden/packer-by-example
