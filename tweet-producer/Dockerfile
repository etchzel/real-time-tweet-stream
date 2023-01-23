FROM python:3.10.7-slim-bullseye

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
    wget \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir
COPY tweet-producer/requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /app
COPY tweet-producer/app/app.py app.py
COPY google_credentials/gcp_key.json gcp_key.json
RUN mkdir lib
COPY tweet-producer/app/lib/tweet_streamer.py lib/tweet_streamer.py

ENTRYPOINT [ "python", "app.py" ]