# syntax=docker/dockerfile:1.2

FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.1

WORKDIR /app
# Install all python dependencies
# RUN uv pip install --system --no-cache \
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
