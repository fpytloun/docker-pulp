FROM volterra.azurecr.io/ves.io/pulp-core

RUN apk add --no-cache py3-gunicorn

ADD entrypoint.sh /entrypoint.sh

USER pulp
RUN django-admin collectstatic --noinput

EXPOSE 24817
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
