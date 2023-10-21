FROM python:3.10-buster as builder

RUN pip install poetry==1.5.1

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN touch README.md

RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --without dev --no-root

# ---------------------------------------------------------

FROM python:3.10-slim-buster as runtime

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

COPY my_try_webapi ./my_try_webapi

ARG PORT=80
ENV PORT=${PORT}
ENV PATH=${PATH}:/app/.venv/bin

EXPOSE 80
CMD [ "ls", "/app/.venv/bin/"]
#CMD ["/app/.venv/bin/uvicorn", "my_try_webapi.main:app", "--host", "0.0.0.0", "--port", "80 "]
#CMD exec uvicorn my_try_webapi.main:app --host 0.0.0.0 --port ${PORT} 
#ENTRYPOINT ["python", "-m", "annapurna.main"]