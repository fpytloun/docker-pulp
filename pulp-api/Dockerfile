FROM pulp-core

ADD entrypoint.sh /entrypoint.sh

EXPOSE 24817
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
