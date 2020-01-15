#!/bin/sh

PULP_API_BIND_PORT=${PULP_API_BIND_PORT:-24817}

gunicorn pulpcore.app.wsgi:application \
          --bind "0.0.0.0:${PULP_API_BIND_PORT}" \
          --access-logfile -
