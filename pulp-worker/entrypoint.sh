#!/bin/bash -e

REDIS_URL=${PULP_REDIS_URL:-"localhost:6379"}
WORKER_NAME=${WORKER_NAME:-"worker@%h"}
rq worker --url "$REDIS_URL" -n "$WORKER_NAME" -w 'pulpcore.tasking.worker.PulpWorker' --disable-job-desc-logging
