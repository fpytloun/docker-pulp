#!/bin/bash -e

source /opt/pulp/scripts/common.sh

setup_secret_keys
ensure_dirs

log_info "Collecting static files"
pulpcore-manager collectstatic --noinput

log_info "Starting content server"
exec gunicorn pulpcore.content:server \
              --bind "0.0.0.0:${PULP_CONTENT_BIND_PORT}" \
              --worker-class 'aiohttp.GunicornWebWorker' \
              -w ${PULP_CONTENT_WORKERS} \
              --access-logfile -
