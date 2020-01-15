#!/bin/sh

PULP_CONTENT_BIND_PORT=${PULP_CONTENT_BIND_PORT:-24816}
PULP_CONTENT_WORKERS=${PULP_CONTENT_WORKERS:-2}

gunicorn pulpcore.app.wsgi:application \
          --bind "0.0.0.0:${PULP_API_BIND_PORT}" \
          --worker-class 'aiohttp.GunicornWebWorker' \
          -w ${PULP_CONTENT_WORKERS}
          --access-logfile -
