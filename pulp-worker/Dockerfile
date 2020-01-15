FROM volterra.azurecr.io/ves.io/pulp-core

ADD entrypoint.sh /entrypoint.sh

USER pulp
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
