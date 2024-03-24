FROM python:3.10-slim as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

WORKDIR /workspace

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.5.1
RUN pip install "poetry==$POETRY_VERSION"

COPY ./app /workspace
COPY pyproject.toml poetry.lock README.md ./
RUN poetry config virtualenvs.in-project true && \
    poetry install --only=main --no-root && \
    poetry build

FROM base as final

COPY --from=builder /workspace/.venv ./.venv
COPY --from=builder /workspace/dist .
COPY --from=builder /workspace/app/ ./app
RUN ./.venv/bin/pip install *.whl && rm *.whl

#WORKDIR app
ARG PORT=80
ENV PORT=${PORT}
ENV PATH=${PATH}:/app/.venv/bin

#EXPOSE 80
#CMD ["/app/.venv/bin/uvicorn", "my_try_webapi.main:app", "--host", "0.0.0.0", "--port", "80 "]
CMD exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT} 
