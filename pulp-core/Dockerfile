FROM fedora:31 as build
ENV PYTHONUNBUFFERED 1

ENV PULP_GIT="https://github.com/pulp/pulpcore.git"
ENV PULP_REF="2d84e2edabeeff56e718e273128ab6a65cf93c16"

# Install build dependencies
RUN yum install -y \
      curl \
      python3 python3-virtualenv python3-devel \
      createrepo_c-devel \
      cmake \
      make \
      gcc \
      git \
      libpq-devel \
      ninja-build \
      cairo-devel \
      libpq-devel \
      rpm-devel \
      file-devel \
      sqlite-devel \
      libxml2-devel \
      zlib-devel \
      expat-devel \
      libmodulemd-devel \
      zchunk-devel

# Install pulp
RUN virtualenv -p python3 /opt/pulp
RUN git clone $PULP_GIT /usr/src/pulpcore && \
    cd /usr/src/pulpcore && git checkout $PULP_REF && \
    /opt/pulp/bin/pip install --no-cache-dir -e .[postgres]

# Install plugins
RUN /opt/pulp/bin/pip install pulp-file pulp-container pulp-rpm

## Main image
FROM fedora:31
ENV PYTHONUNBUFFERED 1
ENV PATH /opt/pulp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV PULP_DATABASES__default__ENGINE="django.db.backends.postgresql_psycopg2" \
    PULP_DATABASES__default__NAME="pulp" \
    PULP_DATABASES__default__USER="pulp"

COPY --from=build /opt/pulp /opt/pulp

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /usr/local/bin/tini

RUN useradd --system -m -d /var/lib/pulp -s /sbin/nologin pulp

RUN yum install -y curl \
      python3 \
      createrepo_c-libs \
      postgresql \
      libpq \
      sqlite \
      libxml2 \
      zlib \
      file-libs \
      libmodulemd \
      expat \
      zchunk-libs \
    && yum clean all

WORKDIR /var/lib/pulp
