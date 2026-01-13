# Packer Template Inventory

This document provides a comprehensive inventory of all available Packer templates in this repository.

## Template Format Legend

- **JSON** - Legacy JSON format (Packer < 1.7.0)
- **HCL2** - Modern HCL2 format (Packer >= 1.5.0, recommended)

## AWS Templates (amazon-ebs)

### Base Operating Systems

| Template                   | OS             | Version   | Format    | Path                              | Description                   |
| -------------------------- | -------------- | --------- | --------- | --------------------------------- | ----------------------------- |
| amazon-ebs.amazon-linux2   | Amazon Linux   | 2         | HCL2      | hcl2/Amazon Linux2/               | Base Amazon Linux 2 image     |
| amazon-ebs.ubuntu1604      | Ubuntu         | 16.04 LTS | JSON      | packfiles/Ubuntu/                 | Ubuntu 16.04 base image (EOL) |
| amazon-ebs.ubuntu1804      | Ubuntu         | 18.04 LTS | JSON      | packfiles/Ubuntu/                 | Ubuntu 18.04 base image       |
| amazon-ebs.ubuntu          | Ubuntu         | Latest    | HCL2      | hcl2/ubuntu/                      | Modern Ubuntu base image      |
| amazon-ebs.ubuntu2210      | Ubuntu         | 22.10     | HCL2      | hcl2/ubuntu2210/                  | Ubuntu 22.10 image            |
| amazon-ebs.centos          | CentOS         | Latest    | JSON      | packfiles/CentOS/                 | CentOS base image             |
| amazon-ebs.redhat          | RedHat         | Latest    | JSON      | packfiles/Redhat/                 | RedHat base image             |
| amazon-ebs.winserver2012r2 | Windows Server | 2012 R2   | JSON      | packfiles/Windows/                | Windows Server 2012 R2 (EOL)  |
| amazon-ebs.winserver2016   | Windows Server | 2016      | JSON      | packfiles/Windows/                | Windows Server 2016           |
| amazon-ebs.winserver2019   | Windows Server | 2019      | JSON/HCL2 | packfiles/Windows/, hcl2/windows/ | Windows Server 2019           |

### Application Stacks

#### Confluent/Kafka Platform

| Template                            | Application     | Format | Path              | Description                            |
| ----------------------------------- | --------------- | ------ | ----------------- | -------------------------------------- |
| amazon-ebs.confluent-broker         | Kafka Broker    | JSON   | packfiles/Redhat/ | Kafka message broker                   |
| amazon-ebs.confluent-zookeeper      | Zookeeper       | JSON   | packfiles/Redhat/ | Confluent Zookeeper for Kafka          |
| amazon-ebs.confluent-schema         | Schema Registry | JSON   | packfiles/Redhat/ | Confluent Schema Registry              |
| amazon-ebs.confluent-control-center | Control Center  | JSON   | packfiles/Redhat/ | Confluent Control Center UI            |
| amazon-ebs.confluent-connect        | Connect         | JSON   | packfiles/Redhat/ | Confluent Connect for data integration |

**Dependencies**: All Confluent templates require the base RedHat image to be built first.

**Provisioning**: Uses Ansible roles from `provisioners/ansible/roles/confluent.*`

#### Cassandra Database

| Template                    | Variant             | OS             | Format | Path                                 | Description                   |
| --------------------------- | ------------------- | -------------- | ------ | ------------------------------------ | ----------------------------- |
| amazon-ebs.cassandra-apache | Apache Cassandra    | Amazon Linux 2 | HCL2   | hcl2/Amazon Linux2/apache-cassandra/ | Apache Cassandra 3.11         |
| amazon-ebs.cassandra-dse    | DataStax Enterprise | Amazon Linux 2 | HCL2   | hcl2/Amazon Linux2/dse-cassandra/    | DataStax Enterprise Cassandra |
| amazon-ebs.cassandra        | Apache Cassandra    | Ubuntu         | JSON   | packfiles/Ubuntu/                    | Apache Cassandra on Ubuntu    |

**Provisioning**: Pre-installed but not started; configured at runtime

#### CI/CD and Tools

| Template                  | Application     | OS     | Format | Path              | Description                     |
| ------------------------- | --------------- | ------ | ------ | ----------------- | ------------------------------- |
| amazon-ebs.jenkins-master | Jenkins         | RedHat | JSON   | packfiles/Redhat/ | Jenkins CI/CD server            |
| amazon-ebs.jmeter         | JMeter          | RedHat | JSON   | packfiles/Redhat/ | Performance testing tool        |
| amazon-ebs.vault          | HashiCorp Vault | Ubuntu | JSON   | packfiles/Ubuntu/ | Secrets management              |
| amazon-ebs.alb-proxy      | ALB Proxy       | RedHat | JSON   | packfiles/Redhat/ | Application Load Balancer Proxy |

### Special Purpose

| Template        | Purpose      | Format | Path            | Description                      |
| --------------- | ------------ | ------ | --------------- | -------------------------------- |
| amazon-ebs.null | Null builder | JSON   | packfiles/null/ | Template for testing/development |

## Azure Templates (azure-arm)

### Linux Images

| Template                    | OS            | Image Type    | Format | Path               | Description           |
| --------------------------- | ------------- | ------------- | ------ | ------------------ | --------------------- |
| azure-arm.ubuntu            | Ubuntu        | Managed Image | JSON   | packfiles/Ubuntu/  | Ubuntu base image     |
| azure-arm.ubuntu_server     | Ubuntu Server | Managed Image | JSON   | packfiles/Ubuntu/  | Ubuntu Server variant |
| azure-arm.ubuntu_custom     | Ubuntu        | Custom Image  | JSON   | packfiles/Ubuntu/  | Customized Ubuntu     |
| azure-arm.ubuntu_quickstart | Ubuntu        | Managed Image | JSON   | packfiles/Ubuntu/  | Quick-start Ubuntu    |
| azure-arm.redhat            | RedHat        | Managed Image | JSON   | packfiles/Redhat/  | RedHat base image     |
| azure-arm.centos            | CentOS        | Managed Image | JSON   | packfiles/CentOS/  | CentOS base image     |
| azure-arm.debian            | Debian        | Managed Image | JSON   | packfiles/Debian/  | Debian base image     |
| azure-arm.freebsd           | FreeBSD       | Managed Image | JSON   | packfiles/freebsd/ | FreeBSD base image    |
| azure-arm.suse              | SUSE          | Managed Image | JSON   | packfiles/suse/    | SUSE Linux base image |

### Windows Images

| Template                     | OS             | Image Type    | Format | Path               | Description            |
| ---------------------------- | -------------- | ------------- | ------ | ------------------ | ---------------------- |
| azure-arm.windows            | Windows Server | Managed Image | JSON   | packfiles/Windows/ | Windows Server 2012 R2 |
| azure-arm.windows_custom     | Windows Server | Custom VHD    | JSON   | packfiles/Windows/ | Custom Windows image   |
| azure-arm.windows_quickstart | Windows Server | Managed Image | JSON   | packfiles/Windows/ | Quick-start Windows    |

## GCP Templates (googlecompute)

| Template              | OS     | Format | Path              | Description        |
| --------------------- | ------ | ------ | ----------------- | ------------------ |
| googlecompute.debian9 | Debian | JSON   | packfiles/Debian/ | Debian 9 (Stretch) |

## Template Features by Category

### Common Features (All Templates)

- ✓ Spot pricing enabled (AWS)
- ✓ Tagged with OS_Version, Application, Runner
- ✓ Source AMI filtering for most recent base images
- ✓ Build number and timestamp versioning

### Cloud-Specific Features

#### AWS Templates Include

- AWS SSM Agent (via Ansible role `dhoeric.aws-ssm`)
- CloudWatch Logs agent
- CloudWatch Metrics agent
- Pre-configured for remote management

#### Azure Templates Include

- Azure Guest Agent support
- Sysprep generalization
- Managed image or VHD output

#### GCP Templates Include

- Google Cloud SDK
- Stackdriver integration

## Provisioning Summary

### Shell Provisioners

Located in `provisioners/scripts/linux/`:

- **Ubuntu**: ansible, aws-cli, aws-ssm, cassandra, docker, powershell, tofu (OpenTofu)
- **RedHat**: ansible, cassandra
- **General**: nginx-firewall, confluent-firewall

### Ansible Provisioners

Located in `provisioners/ansible/`:

#### Roles (19 total)

- **AWS Integration**: aws-ssm, cloudwatch-logs, cloudwatch-metrics, ssmagent
- **Confluent Platform**: confluent.common, confluent.kafka-broker, confluent.zookeeper, confluent.schema-registry, confluent.control-center, confluent.connect-distributed, confluent.ssl_CA
- **Databases**: cassandra
- **Development**: openjdk (devoinc.openjdk)
- **CI/CD**: jenkins, jmeter
- **Monitoring**: datadog

#### Playbooks (17 total)

Key playbooks for complete application stacks:

- `confluent.yml` - Full Confluent platform
- `cassandra.yml` - Cassandra database
- `jenkins-master.yml` - Jenkins server
- `aws-ssm.yml` - AWS Systems Manager agent

## Building Templates

### Prerequisites

1. Install Packer 1.11.2+: `./setup-packer.sh`
2. Configure cloud credentials (see docs/AWS.MD, docs/AZURE.MD, docs/GCP.MD)
3. Install Ansible Galaxy dependencies: `ansible-galaxy install -r provisioners/ansible/requirements.yml`
4. Create environment file: `environment/<your-env>.json`

### Build Examples

```bash
# AWS Ubuntu base image
./build.sh -p packfiles/Ubuntu/amazon-ebs.ubuntu1804.json -e environment/dev.json

# Windows Server 2019 (requires WINRM_PASSWORD env var)
export WINRM_PASSWORD=...
./build.sh -p packfiles/Windows/amazon-ebs.winserver2019.json -e environment/dev.json

# HCL2 template
cd hcl2/ubuntu && packer build .

# Confluent Kafka Broker (requires base RedHat AMI)
./build.sh -p packfiles/Redhat/amazon-ebs.confluent-broker.json -e environment/prod.json
```

### Makefile

```bash
# Build using Makefile
make base PACKFILE=packfiles/Ubuntu/amazon-ebs.ubuntu1804.json ENVIRONMENT=environment/dev.json

# Validate all templates
make validate
```

## Migration Notes

### JSON → HCL2 Migration Status

| Template Type | Status     | Notes                                   |
| ------------- | ---------- | --------------------------------------- |
| Ubuntu AWS    | ✓ Partial  | Some templates migrated to hcl2/ubuntu/ |
| Windows AWS   | ✓ Partial  | Windows 2019 available in HCL2          |
| Amazon Linux  | ✓ Complete | All in HCL2 format                      |
| Azure         | ✗ Pending  | All still JSON                          |
| GCP           | ✗ Pending  | All still JSON                          |
| Confluent     | ✗ Pending  | All still JSON                          |

**Recommendation**: New templates should use HCL2 format. JSON templates are maintained for compatibility.

## Version Requirements

### Operating Systems Status

| OS              | Version          | Status             | Recommendation        |
| --------------- | ---------------- | ------------------ | --------------------- |
| Ubuntu 16.04    | EOL (Apr 2021)   | ⚠️ Deprecated      | Upgrade to 22.04 LTS  |
| Ubuntu 18.04    | EOL (Apr 2023)   | ⚠️ Deprecated      | Upgrade to 22.04 LTS  |
| Ubuntu 22.10    | Short-term       | ⚠️ Limited support | Use 22.04 LTS instead |
| Windows 2012 R2 | EOL (Oct 2023)   | ⚠️ Deprecated      | Upgrade to 2019/2022  |
| Amazon Linux 2  | Supported        | ✓ Current          | -                     |
| Windows 2016    | Extended support | ⚠️ Limited         | Upgrade to 2019/2022  |
| Windows 2019    | Supported        | ✓ Current          | -                     |

## Template Dependencies

Some templates require other AMIs to be built first:

```text
RedHat Base AMI
 ├─ confluent-broker
 ├─ confluent-zookeeper
 ├─ confluent-schema
 ├─ confluent-control-center
 ├─ confluent-connect
 ├─ jenkins-master
 ├─ jmeter
 └─ alb-proxy
```

## Security Considerations

### Secrets Management

- ✓ AWS credentials via environment variables
- ✓ Windows passwords via `WINRM_PASSWORD` environment variable (not hardcoded)
- ✓ Azure credentials via ARM\_\* environment variables
- ⚠️ Some SSL/TLS passwords in templates marked "REPLACEME" - update before use

### Compliance

- Pre-commit hooks configured for:
  - Credential scanning (detect-secrets)
  - Shell script linting (shellcheck)
  - Markdown linting

## Additional Resources

- [AWS Setup Guide](AWS.MD)
- [Azure Setup Guide](AZURE.MD)
- [GCP Setup Guide](GCP.MD)
- [AMI Lifecycle Management](AMI-LIFECYCLE.md)
- [Main README](../README.md)
