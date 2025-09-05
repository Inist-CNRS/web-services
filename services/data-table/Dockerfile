# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg=7:4.3.9-0+deb11u1 \
    libsm6=2:1.2.3-1 \
    libxext6=2:1.3.3-1.1 \
    tesseract-ocr=4.1.1-2.1 \
    tesseract-ocr-fra=1:4.00~git30-7274cfa-1.1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install all python dependencies
RUN pip install --no-cache-dir \
    img2table==1.4.2 \
    numba==0.58.1 \
    opencv-contrib-python==4.11.0.86 \
    pillow==10.1.0

WORKDIR /app/public
# Modification in image2table library to delete the printing in the stdout
RUN sed -i -e 's/cmd_tess = subprocess.run("tesseract --version", env=self.env, shell=True, check=False)/cmd_tess = subprocess.run("tesseract --version", env=self.env, shell=True, check=False, stdout=subprocess.PIPE)/g' /usr/local/lib/python3.9/site-packages/img2table/ocr/tesseract.py
ENV NUMBA_CACHE_DIR=/tmp/numba_cache
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
COPY --chown=daemon:daemon ./config.json /app/config.json
