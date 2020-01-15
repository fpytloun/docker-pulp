FROM python:3.6-alpine

ENV PULP_GIT="https://github.com/pulp/pulpcore.git"
ENV PULP_REF="2d84e2edabeeff56e718e273128ab6a65cf93c16"

ENV PULP_DATABASES__default__ENGINE="django.db.backends.postgresql_psycopg2" \
    PULP_DATABASES__default__NAME="pulp" \
    PULP_DATABASES__default__USER="pulp"

RUN addgroup -S pulp && \
    adduser -S -D -G pulp -h /var/lib/pulp -s /sbin/nologin pulp

RUN apk add --no-cache tini bash curl

RUN apk add --no-cache --virtual .build-deps \
    build-base \
    cmake \
    curl-dev \
    gcc \
    git \
    libpq \
    ninja \
    meson \
    musl \
    musl-dev \
    postgresql-dev \
    file-dev \
    rpm-dev \
    sqlite-dev \
    cairo-dev \
    gobject-introspection-dev \
    zlib-dev \
    libxml2-dev \
    expat-dev \
    python3-dev && \
    # Install zchunk dependency
    git clone https://github.com/zchunk/zchunk.git /usr/src/zchunk && \
    cd /usr/src/zchunk && meson build && cd build && ninja && ninja test && ninja install && \
    # Install pulp
    git clone $PULP_GIT /usr/src/pulpcore && \
    cd /usr/src/pulpcore && git checkout $PULP_REF && \
    pip install --no-cache-dir -e .[postgres] && \
    # Install plugins
    pip install pulp-file pulp-container pulp-rpm && \
    # Cleanup
    apk del .build-deps && \
    cd / && rm -rf /var/cache/apk/* /usr/src/*

WORKDIR /var/lib/pulp
