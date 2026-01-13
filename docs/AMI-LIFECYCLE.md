# AMI Lifecycle Management

## Overview

As you build AMIs regularly, it's important to manage their lifecycle to avoid accumulating unnecessary AMIs and their associated EBS snapshots, which incur storage costs.

## AMI Cleanup Script

The repository includes an `ami-cleanup.sh` script to help manage AMI retention and cleanup.

### Basic Usage

```bash
# Dry run - see what would be deleted
./ami-cleanup.sh -d

# Keep the 3 most recent AMIs, delete older ones
./ami-cleanup.sh -n 3

# Specify a region
./ami-cleanup.sh -n 5 -r eu-west-1

# Filter by AMI name prefix
./ami-cleanup.sh -p "Windows2019" -n 2

# Combine options
./ami-cleanup.sh -n 3 -r us-east-1 -p "Base v" -d
```

### Options

- `-n NUM_TO_KEEP` - Number of most recent AMIs to retain (default: 3)
- `-r REGION` - AWS region (default: from AWS_REGION env var or us-east-1)
- `-p PREFIX` - AMI name prefix filter (default: "Base v")
- `-d` - Dry run mode - shows what would be deleted without actually deleting
- `-h` - Show help message

### What It Does

1. Lists all AMIs owned by your account matching the specified prefix
2. Sorts them by creation date (newest first)
3. Identifies AMIs older than the retention threshold
4. Deregisters old AMIs
5. Deletes associated EBS snapshots

### Best Practices

#### 1. Always Start with a Dry Run

```bash
./ami-cleanup.sh -n 3 -d
```

Review the output to ensure you're not deleting anything critical.

#### 2. Set Appropriate Retention Policies

- **Production images**: Keep 5-10 recent versions for rollback capability
- **Development images**: Keep 2-3 recent versions
- **Test images**: Keep 1-2 recent versions

#### 3. Automate Cleanup

Add to cron for regular cleanup:

```bash
# Cleanup weekly (every Sunday at 2 AM)
0 2 * * 0 /path/to/ami-cleanup.sh -n 5 -r us-east-1 >> /var/log/ami-cleanup.log 2>&1
```

#### 4. Use Distinct Prefixes

Organize AMIs with clear naming conventions:

```bash
./ami-cleanup.sh -p "Production-WebServer" -n 5
./ami-cleanup.sh -p "Dev-Database" -n 2
./ami-cleanup.sh -p "Test-" -n 1
```

## Alternative: AWS Data Lifecycle Manager

For more sophisticated lifecycle management, consider [AWS Data Lifecycle Manager](https://aws.amazon.com/ebs/data-lifecycle-manager/):

### Example DLM Policy (OpenTofu/Terraform)

```hcl
resource "aws_dlm_lifecycle_policy" "ami_lifecycle" {
  description        = "AMI lifecycle policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["INSTANCE"]

    schedule {
      name = "2 weeks retention"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["03:00"]
      }

      retain_rule {
        count = 14
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = true
    }

    target_tags = {
      ManagedBy = "Packer"
    }
  }
}
```

## Cost Optimization Tips

1. **Regular Cleanup**: AMIs themselves don't cost money, but their EBS snapshots do
2. **Monitor Snapshot Usage**: Check EBS snapshot costs in AWS Cost Explorer
3. **Tag Your AMIs**: Use consistent tagging for easier lifecycle management
4. **Cross-Region Cleanup**: Remember to clean up AMIs in all regions where you build them

## Automated Cleanup in CI/CD

### Example Jenkins Pipeline Stage

```groovy
stage('Cleanup Old AMIs') {
    steps {
        sh '''
            ./ami-cleanup.sh -n 5 -r ${AWS_REGION} -p "Base v"
        '''
    }
}
```

### Example GitHub Actions Workflow

```yaml
name: AMI Cleanup
on:
  schedule:
    - cron: "0 2 * * 0" # Weekly on Sunday at 2 AM
  workflow_dispatch: # Allow manual trigger

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1
      - name: Run AMI cleanup
        run: |
          chmod +x ./ami-cleanup.sh
          ./ami-cleanup.sh -n 5
```

## Monitoring and Alerts

Set up CloudWatch alarms for:

1. **High snapshot count**: Alert when snapshots exceed threshold
2. **Storage costs**: Alert when EBS snapshot costs increase unexpectedly
3. **Failed cleanups**: Monitor cleanup script exit codes

## Emergency Recovery

If you accidentally delete an AMI:

1. **From snapshot**: You can create a new AMI from the snapshot if it still exists
2. **From backup**: Rebuild from your Packer templates
3. **From running instance**: Create an AMI from a running instance based on the deleted AMI

```bash
# Create AMI from existing snapshot
aws ec2 register-image \
  --name "Recovered-AMI-Name" \
  --root-device-name /dev/xvda \
  --block-device-mappings DeviceName=/dev/xvda,Ebs={SnapshotId=snap-xxxxx}
```

## References

- [AWS AMI Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
- [AWS Data Lifecycle Manager](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html)
- [EBS Snapshot Pricing](https://aws.amazon.com/ebs/pricing/)
