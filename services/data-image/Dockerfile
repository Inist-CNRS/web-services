FROM cnrsinist/ezs-python-server:py3.9-no24-1.0.14

WORKDIR /app

# Install only Python dependencies not provided by the base image
RUN pip install --no-cache-dir \
    opencv-python-headless==5.0.0.93 \
    PyMuPDF==1.26.5 \
    Pillow==11.3.0

WORKDIR /app/public

# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json

# Copy DVC files
#COPY --chown=daemon:daemon --from=dvc-files /dvc/data/ /app/public/v1/