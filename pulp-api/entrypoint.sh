#!/bin/bash -e

source /opt/pulp/scripts/common.sh

setup_secret_keys
ensure_dirs

log_info "Collecting static files"
pulpcore-manager collectstatic --noinput

log_info "Updating database schema"
pulpcore-manager migrate --noinput

if [[ -n "$PULP_ADMIN_PASSWORD" ]]; then
    log_info "Setting admin password"
    pulpcore-manager reset-admin-password --password "${PULP_ADMIN_PASSWORD}"
fi

log_info "Starting API server"
exec gunicorn pulpcore.app.wsgi:application \
              --bind "0.0.0.0:${PULP_API_BIND_PORT}" \
              --timeout ${PULP_WORKER_TIMEOUT:-30} \
              --access-logfile -
