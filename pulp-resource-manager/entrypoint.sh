#!/bin/bash -e

REDIS_URL=${PULP_REDIS_URL:-"localhost:6379"}
rq worker --url "$REDIS_URL" -n 'resource-manager' -w 'pulpcore.tasking.worker.PulpWorker' --disable-job-desc-logging
