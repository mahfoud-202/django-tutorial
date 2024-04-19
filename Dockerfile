
FROM python:3.12.2-slim-bookworm

# ********************************************************
# *** Poetry ***
#
# for full documentation visit:
#
# https://python-poetry.org/docs/#installation
# https://python-poetry.org/docs/configuration/
# ********************************************************

# specify the version of poetry we are installing
ENV POETRY_VERSION=1.8.2

# specify the directory for storing poetry's installation
ENV POETRY_HOME="/app/.poetry"

# specify the path to the cache directory used by poetry
ENV POETRY_CACHE_DIR="/app/.poetry/.cache"

# disable all interactive prompts
ENV POETRY_NO_INTERACTION=1

# prepend poetry to path
ENV PATH="$POETRY_HOME/bin:$PATH"

# update and upgrade packages install curl without recommended packages
# and clean up apt cache
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install poetry
RUN curl -sSL https://install.python-poetry.org | python -

# set working directory
WORKDIR /app

# copy project configuration files separately for efficient caching
COPY pyproject.toml poetry.lock .

# install project main dependencies
RUN poetry install --only main

# copy the remaining project files to the /app directory
COPY . .

# specify that the container will listen on port 8000
EXPOSE 8000

# run the django development server
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
