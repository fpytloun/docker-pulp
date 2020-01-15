# Pulp Docker images

Pulp installation consists of 4 containers:

- pulp-api
- pulp-content
- pulp-resource-manager
- pulp-worker

All of these images are using `pulp-core` as a base image.

## Configuration

To run and configure Pulp, you have 2 options:

1. Export `PULP_SETTINGS` to location with your configuration file and manage
   it as host path od Kubernetes configmap.
   Pulp is using [Dynaconf](https://dynaconf.readthedocs.io/en/latest/guides/examples.html)_ so you can use various formats.
2. Use environment variables entirely to configure Pulp, we are going to use
   this option.

### Configuration options

- `PULP_SECRET_KEY`

   ```
   import random

   chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'
   print(''.join(random.choice(chars) for i in range(50)))
   ```

- `PULP_DATABASES__default__ENGINE` (defaults to `django.db.backends.postgresql_psycopg2`)
- `PULP_DATABASES__default__USER` (defaults to `pulp`)
- `PULP_DATABASES__default__PASSWORD`
- `PULP_DATABASES__default__NAME` (defaults to `pulp`)
- `PULP_DATABASES__default__HOST`

- `PULP_REDIS_URL` (eg. `redis://redis.pulp.svc.cluster.local:6379/1`)

- `CONTENT_ORIGIN` - pointer to content service (eg. `https://pulp.example.com:24816`)
- `CONTENT_PATH_PREFIX` - defaults to `/pulp/content/`

## Installation

### First run

pulp-api entrypoint will automatically handle database upgrades by running

```
django-admin migrate --noinput
```

However you should set admin password on your own by exec in pulp-api
container and running:

```
django-admin reset-admin-password --password <yoursecretpassword>
```

## Development

To deploy pulp locally for development and testing purposes, use
docker-compose:

```
docker-compose up
```
