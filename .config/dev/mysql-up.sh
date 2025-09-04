#!/usr/bin/env bash
set -euo pipefail
log(){ echo "[mysql-up] $*"; }

# Docker daemon 준비될 때까지 충분히 대기 (최대 10분)
end=$((SECONDS+600))
until docker info >/dev/null 2>&1; do
  if (( SECONDS > end )); then
    log "Docker daemon not ready (timeout). Will retry in background."
    exit 0
  fi
  sleep 5
done

docker network inspect devnet >/dev/null 2>&1 || docker network create devnet >/dev/null 2>&1 || true

if ! docker ps --format '{{.Names}}' | grep -q '^mysql-db$'; then
  (cd ~/.config/dev && docker compose up -d)
  log "mysql-db started."
else
  log "mysql-db already running."
fi
