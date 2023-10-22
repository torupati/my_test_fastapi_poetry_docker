FROM python:3.10-buster as requirements-stage

WORKDIR /tmp
RUN pip install poetry
COPY ./pyproject.toml ./poetry.lock* /tmp/
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

# ------------------------------------------------------------------------------
FROM python:3.10-slim-buster as runtime
ARG PORT=80

WORKDIR /code
COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt

# Following is to cope with 
# ImportError: libGL.so.1: cannot open share object file
RUN apt-get update && apt-get install libgl1 libglib2.0-0 -y && apt-get clean && rm -rf /var/lib/apg/lists/*

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./my_try_webapi /code/my_try_webapi
#CMD ["uvicorn", "my_try_webapi.main:app", "--host", "0.0.0.0", "--port", "80"]
CMD exec uvicorn my_try_webapi.main:app --host 0.0.0.0 --port ${PORT} 
