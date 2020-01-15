#!/bin/bash -e

PULP_API_BIND_PORT=${PULP_API_BIND_PORT:-24817}

echo "[INFO] Collecting static files"
django-admin collectstatic --noinput

echo "[INFO] Updating database schema"
django-admin migrate --noinput

if [[ -n $PULP_ADMIN_PASSWORD ]]; then
    echo "[INFO] Setting admin password"
    django-admin reset-admin-password --password ${PULP_ADMIN_PASSWORD}
fi

echo "[INFO] Starting API server"
gunicorn pulpcore.app.wsgi:application \
          --bind "0.0.0.0:${PULP_API_BIND_PORT}" \
          --access-logfile -
