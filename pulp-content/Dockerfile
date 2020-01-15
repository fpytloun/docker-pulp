FROM volterra.azurecr.io/ves.io/pulp-core

RUN apk add --no-cache py3-gunicorn

ADD entrypoint.sh /entrypoint.sh

USER pulp

EXPOSE 24816
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
