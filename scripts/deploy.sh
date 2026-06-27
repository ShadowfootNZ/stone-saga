#!/usr/bin/env bash
set -euo pipefail

# Write the private key to a temp file
KEY_FILE=$(mktemp)
echo "$SSH_PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

SSH_OPTS="-i $KEY_FILE -p ${SSH_PORT:-22} -o StrictHostKeyChecking=${SSH_STRICT_HOST_KEY_CHECKING:-no}"

rsync -az --delete \
  -e "ssh $SSH_OPTS" \
  --exclude='.git/' \
  --exclude='.github/' \
  --exclude='scripts/' \
  "$DEPLOY_DIR/" \
  "$SSH_USER@$SSH_HOST:$REMOTE_PATH"

rm -f "$KEY_FILE"
echo "Deployed to $SSH_HOST:$REMOTE_PATH"
