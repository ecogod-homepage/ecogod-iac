#!/usr/bin/env bash
set -euo pipefail

PROFILE="${AWS_PROFILE:-capstone}"
REGION="${AWS_REGION:-ap-northeast-2}"

usage() {
  echo "Usage: AWS_PROFILE=capstone AWS_REGION=ap-northeast-2 $0 <parameter-name> <value>"
}

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

aws ssm put-parameter \
  --profile "$PROFILE" \
  --region "$REGION" \
  --name "$1" \
  --type SecureString \
  --overwrite \
  --value "$2"
