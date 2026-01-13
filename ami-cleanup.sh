#!/bin/bash
# AMI Cleanup Script
# This script helps manage AMI lifecycle by cleaning up old AMIs while retaining the most recent versions
# Usage: ./ami-cleanup.sh [-n NUM_TO_KEEP] [-r REGION] [-p PREFIX] [-d]
#
# Options:
#   -n NUM_TO_KEEP  Number of AMIs to keep (default: 3)
#   -r REGION       AWS region (default: from AWS_REGION env var or us-east-1)
#   -p PREFIX       AMI name prefix filter (default: "Base v")
#   -d              Dry run - show what would be deleted without actually deleting
#   -h              Show this help message

set -eo pipefail

# Default values
NUM_TO_KEEP=3
REGION="${AWS_REGION:-us-east-1}"
PREFIX="Base v"
DRY_RUN=false

# Parse command line arguments
while getopts "n:r:p:dh" opt; do
  case ${opt} in
    n )
      NUM_TO_KEEP=$OPTARG
      ;;
    r )
      REGION=$OPTARG
      ;;
    p )
      PREFIX=$OPTARG
      ;;
    d )
      DRY_RUN=true
      ;;
    h )
      grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //'
      exit 0
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

echo "======================================"
echo "AMI Cleanup Configuration"
echo "======================================"
echo "Region:        $REGION"
echo "AMI Prefix:    $PREFIX"
echo "Keep Recent:   $NUM_TO_KEEP"
echo "Dry Run:       $DRY_RUN"
echo "======================================"
echo ""

# Get list of AMIs owned by this account matching the prefix, sorted by creation date
echo "Fetching AMIs with prefix: $PREFIX"
AMIS=$(aws ec2 describe-images \
  --region "$REGION" \
  --owners self \
  --filters "Name=name,Values=${PREFIX}*" \
  --query 'Images[*].[ImageId,Name,CreationDate]' \
  --output text | sort -k3 -r)

if [ -z "$AMIS" ]; then
  echo "No AMIs found matching prefix: $PREFIX"
  exit 0
fi

# Count total AMIs
TOTAL_AMIS=$(echo "$AMIS" | wc -l | tr -d ' ')
echo "Found $TOTAL_AMIS AMIs matching the prefix"
echo ""

# Calculate how many to delete
NUM_TO_DELETE=$((TOTAL_AMIS - NUM_TO_KEEP))

if [ "$NUM_TO_DELETE" -le 0 ]; then
  echo "No AMIs to delete. Current count ($TOTAL_AMIS) <= Keep threshold ($NUM_TO_KEEP)"
  exit 0
fi

echo "Will delete $NUM_TO_DELETE AMI(s) and keep the $NUM_TO_KEEP most recent"
echo ""

# Get AMIs to delete (skip the first NUM_TO_KEEP)
AMIS_TO_DELETE=$(echo "$AMIS" | tail -n "$NUM_TO_DELETE")

echo "AMIs to be deleted:"
echo "-------------------"
echo "$AMIS_TO_DELETE" | awk '{printf "  %s - %s (created: %s)\n", $1, $2, $3}'
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "DRY RUN MODE - No AMIs will be deleted"
  echo ""
  echo "To actually delete these AMIs, run without the -d flag"
  exit 0
fi

# Confirm deletion
read -p "Are you sure you want to delete these $NUM_TO_DELETE AMI(s)? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "Deletion cancelled"
  exit 0
fi

echo ""
echo "Deleting AMIs..."

# Delete each AMI and its associated snapshots
echo "$AMIS_TO_DELETE" | while read -r ami_id ami_name creation_date; do
  echo "Processing $ami_id ($ami_name, created: $creation_date)..."

  # Get associated snapshots before deregistering
  SNAPSHOTS=$(aws ec2 describe-images \
    --region "$REGION" \
    --image-ids "$ami_id" \
    --query 'Images[0].BlockDeviceMappings[*].Ebs.SnapshotId' \
    --output text)

  # Deregister the AMI
  echo "  Deregistering AMI: $ami_id"
  aws ec2 deregister-image --region "$REGION" --image-id "$ami_id"

  # Delete associated snapshots
  if [ -n "$SNAPSHOTS" ]; then
    for snapshot in $SNAPSHOTS; do
      echo "  Deleting snapshot: $snapshot"
      aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snapshot" || \
        echo "    Warning: Failed to delete snapshot $snapshot (may be in use)"
    done
  fi

  echo "  ✓ Completed deletion of $ami_id"
done

echo ""
echo "======================================"
echo "Cleanup completed successfully!"
echo "Deleted: $NUM_TO_DELETE AMI(s)"
echo "Retained: $NUM_TO_KEEP AMI(s)"
echo "======================================"
