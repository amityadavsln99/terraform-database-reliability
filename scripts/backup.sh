#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="terraform-db-reliability-postgres"
DB_NAME="appdb"
DB_USER="appuser"

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/backups"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
BACKUP_FILE="${BACKUP_DIR}/appdb_${TIMESTAMP}.dump"

mkdir -p "$BACKUP_DIR"

echo "Creating PostgreSQL backup..."

docker exec "$CONTAINER_NAME" \
  pg_dump \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -Fc \
  > "$BACKUP_FILE"

echo "Backup created successfully:"
echo "$BACKUP_FILE"