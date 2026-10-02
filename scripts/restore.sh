#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="terraform-db-reliability-postgres"
DB_NAME="appdb"
DB_USER="appuser"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Restoring database from:"
echo "$BACKUP_FILE"

cat "$BACKUP_FILE" | docker exec -i "$CONTAINER_NAME" \
  pg_restore \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  --clean \
  --if-exists

echo "Database restore completed successfully."