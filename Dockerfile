FROM python:3.10-slim as base
# Python setup
ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

WORKDIR /app

FROM base as builder
# Prepare poetry and install
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.3.1

RUN pip install "poetry==$POETRY_VERSION"

COPY pyproject.toml poetry.lock README.md ./
COPY my_try_webapi ./my_try_webapi
RUN poetry config virtualenvs.in-project true && \
    poetry install --only=main --no-root && \
    poetry build

#FROM base as final
#COPY --from=builder /app/.venv ./.venv
#COPY --from=builder /app/dist .
#COPY docker-entrypoint.sh .
#RUN ./.venv/bin/pip install *.whl
#WORKDIR app

EXPOSE 80
CMD ["/app/.venv/bin/uvicorn", "my_try_webapi.main:app", "--host", "0.0.0.0", "--port", "80"]