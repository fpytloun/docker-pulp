#!/bin/bash -e

source /opt/pulp/scripts/common.sh

setup_secret_keys
ensure_dirs

log_info "Starting Worker"
exec pulpcore-worker
