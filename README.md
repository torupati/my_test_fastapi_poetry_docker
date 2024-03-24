# my_test_fastapi_poetry_docker

This is my test code to use poetry for fastapi in Docker.

## Docker

```
$ docker compose build --no-cache
$ docker compose up -d
$ docker compose logs -f
```

## MEMO

This repository is my test to how to write multi-stage docker build and docker-compose.

For multi-stage build with poetry, several strategies seems available.

(1) Make requirements.txt and pip install.
(2) Copy virtual envirement directory from build container.

