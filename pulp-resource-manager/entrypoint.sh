#!/bin/sh

REDIS_URL=${PULP_REDIS_URL:-"localhost:6379"}
rq worker --url "$redis_url_string" -n 'resource-manager' -w 'pulpcore.tasking.worker.PulpWorker' --disable-job-desc-logging
