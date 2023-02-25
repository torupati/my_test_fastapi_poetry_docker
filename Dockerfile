FROM python:3.8.8-slim as python-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    POETRY_VERSION=1.3.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_CREATE=false \
    \
    PYSETUP_PATH="/opt/pysetup"

ENV PATH="$POETRY_HOME/bin:$PATH"

FROM python-base as initial
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
RUN pip3 install poetry

WORKDIR $PYSETUP_PATH

FROM initial as development-base
ENV POETRY_NO_INTERACTION=1
COPY poetry.lock pyproject.toml ./

FROM development-base as development
RUN poetry install 
# -- no-dev

FROM python-base as production
COPY --from=builder-base /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY ./my_try_webapi /app/
WORKDIR /app
EXPOSE 80
CMD ["uvicorn", "my_try_webapi.main:app", "--host", "0.0.0.0", "--port", "80"]