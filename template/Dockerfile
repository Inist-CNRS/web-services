# syntax=docker/dockerfile:1.2

# FROM ghcr.io/astral-sh/uv:0.12.12-python3.10-trixie-slim AS dvc-files
# WORKDIR /dvc
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends git=1:2.47.3-0+deb13u1 && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
# RUN uv pip install --system --no-cache-dir dvc[webdav]==3.67.1
# RUN --mount=type=secret,id=webdav_login \
#     --mount=type=secret,id=webdav_password \
#     --mount=type=secret,id=webdav_url \
#     git init && \
#     dvc init && \
#     dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
#     dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
#     dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
# COPY ./v1/data.dvc /dvc
## The cat part is useful for files larger than 500Mio.
# RUN dvc pull -vv && \
#     cat data/x* > data/resources.txt && \
#     rm data/x*

FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.0

WORKDIR /app
# Install all python dependencies
# RUN uv pip install --system --no-cache-dir \
#     unidecode==1.4.0

# Install all node dependencies
# RUN npm install --omit=dev \
#         @ezs/teeft@2.3.5 \
#         @ezs/strings@1.0.6 && \
#     npm cache clean --force

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
