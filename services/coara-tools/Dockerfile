FROM python:3.9-slim-bullseye AS dvc-files
WORKDIR /dvc
RUN apt update && apt -y install git
RUN pip install dvc[webdav]==3.39.0
RUN --mount=type=secret,id=webdav_login \
    --mount=type=secret,id=webdav_password \
    --mount=type=secret,id=webdav_url \
    git init && \
    dvc init && \
    dvc remote add -d webdav-remote "$(cat /run/secrets/webdav_url)" && \
    dvc remote modify --local webdav-remote user "$(cat /run/secrets/webdav_login)" && \
    dvc remote modify --local webdav-remote password "$(cat /run/secrets/webdav_password)"
RUN dvc doctor
COPY ./v1/fasttext_model.bin.dvc /dvc
RUN dvc pull -v


FROM cnrsinist/ezs-python-pytorch-server:py3.9-no16-1.1.4

USER root
# Install all python dependencies
RUN pip install fasttext-wheel==0.9.2 \
    nltk==3.9.1 \
    prometheus-client==0.19.0

# To dl punkt only once
RUN [ "python3", "-c", "import nltk; nltk.download('punkt_tab', download_dir='/usr/local/nltk_data')" ]

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv /app/public/config.json /app && chmod a+w /app/config.json
RUN mkdir /tmp/retrieve

COPY --chown=daemon:daemon --from=dvc-files /dvc/fasttext_model.bin /app/public/v1/fasttext_model.bin
