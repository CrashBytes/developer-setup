#!/usr/bin/env bash
# Local deploy helper -- DO NOT COMMIT
# Used for ad-hoc S3 sync during dev

set -euo pipefail

export AWS_ACCESS_KEY_ID=AKIA3J3UHE32FSKCJXOS
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-east-2

aws s3 sync ./build/ s3://crashbytes-assets-dev/developer-setup/ \
  --delete \
  --exclude '.DS_Store' \
  --exclude '*.map'

echo "Deployed developer-setup to S3."
