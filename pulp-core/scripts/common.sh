### Variables ###

# Our specifics
PULP_API_BIND_PORT=${PULP_API_BIND_PORT:-24817}
PULP_CONTENT_BIND_PORT=${PULP_CONTENT_BIND_PORT:-24816}
PULP_CONTENT_WORKERS=${PULP_CONTENT_WORKERS:-2}
PULP_REDIS_URL=${PULP_REDIS_URL:-"localhost:6379"}
PULP_WORKER_NAME=${WORKER_NAME:-"worker@%h"}
PULP_DATADIR=${PULP_BASEDIR:-"/var/lib/pulp"}
PULP_CONFDIR=${PULP_CONFDIR:-"/etc/pulp"}

# Dynaconf
export PULP_DB_ENCRYPTION_KEY=${DB_ENCRYPTION_KEY:-"/etc/pulp/certs/database_fields.symmetric.key"}

### Functions ###

log_info() {
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S.0%z') [INFO] $*"
}

log_error() {
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S.0%z') [ERROR] $*" 1>&2
}

setup_db_encryption_key() {
    if [ -e "$PULP_DB_ENCRYPTION_KEY" ]; then
        log_info "$PULP_DB_ENCRYPTION_KEY already exists"
        return
    fi

    if [[ -n $PULP_DB_ENCRYPTION_KEY_VALUE ]]; then
        log_info "Using value from PULP_DB_ENCRYPTION_KEY_VALUE env variable as encryption key"
        [ -d "${PULP_DB_ENCRYPTION_KEY%/*}" ] || mkdir -p "${PULP_DB_ENCRYPTION_KEY%/*}"
        echo -n "${PULP_DB_ENCRYPTION_KEY_VALUE}" > ${PULP_DB_ENCRYPTION_KEY}
    else
        log_error "You need to set PULP_DB_ENCRYPTION_KEY_VALUE variable or provide ${PULP_DB_ENCRYPTION_KEY}"
        exit 1
        # Generate one on shared storage (development only)
        # export DB_ENCRYPTION_KEY="${PULP_DATADIR}/conf/database_fields.symmetric.key"
        # [ -d "${PULP_DB_ENCRYPTION_KEY%/*}" ] || mkdir -p "${PULP_DB_ENCRYPTION_KEY%/*}"
        # if [ -f "${PULP_DB_ENCRYPTION_KEY}" ]; then
        #     log_info "Using database encryption key on shared storage path ${PULP_DB_ENCRYPTION_KEY}"
        # else
        #     log_info "Generating database encryption key on shared storage path ${PULP_DB_ENCRYPTION_KEY}"
        #     openssl rand -base64 32 > ${PULP_DB_ENCRYPTION_KEY}
        # fi
    fi
}

setup_secret_keys() {
    setup_db_encryption_key
}

ensure_dirs() {
    for dir in media tmp; do
        [ -d ${PULP_DATADIR}/${dir} ] || mkdir -p ${PULP_DATADIR}/${dir}
    done
}
