dhoeric.aws-ssm
=========

[![Build Status](https://travis-ci.org/dhoeric/ansible-aws-ssm.svg?branch=master)](https://travis-ci.org/dhoeric/ansible-aws-ssm)
[![Ansible Role](https://img.shields.io/ansible/role/17714.svg)](https://galaxy.ansible.com/dhoeric/aws-ssm/)
[![Ansible Role](https://img.shields.io/ansible/role/d/17714.svg)](https://galaxy.ansible.com/dhoeric/aws-ssm/)

Install AWS EC2 Systems Manager (SSM) agent

<http://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html>

Requirements
------------

None

Role Variables
--------------

Available variables are listed below, along with default values:

```yaml
# The defaults provided by this role are specific to each distribution.
url: 'amd64'
```

For installation in [Raspbian](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-manual-agent-install.html#agent-install-raspbianjessie), please find the activation code and id before using this role

```yaml
url: 'arm'
aws_ssm_activation_code:
aws_ssm_activation_id:
aws_ssm_ec2_region: "{{ec2_region}}"
```

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
    - hosts: servers
      roles:
         - { role: dhoeric.aws-ssm }
```

License
-------

MIT

Author Information
------------------

<https://www.github.com/dhoeric>
