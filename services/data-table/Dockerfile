# syntax=docker/dockerfile:1.2
FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.12

USER root
# Install all python dependencies

RUN apt update && apt install -y tesseract-ocr=4.1.1-2.1 tesseract-ocr-fra=1:4.00~git30-7274cfa-1.1 ffmpeg=7:4.3.9-0+deb11u1 libsm6=2:1.2.3-1 libxext6=2:1.3.3-1.1

RUN pip install \
    numba==0.58.1 \
    img2table==1.4.2 \
    opencv-contrib-python==4.11.0.86 \
    pillow==10.1.0

# Install all node dependencies
# RUN npm install \
#     @ezs/teeft@2.3.1 \
#     @ezs/strings@1.0.3

WORKDIR /app/public
# Modification in image2table library to delete the printing in the stdout
RUN sed -i -e 's/cmd_tess = subprocess.run("tesseract --version", env=self.env, shell=True, check=False)/cmd_tess = subprocess.run("tesseract --version", env=self.env, shell=True, check=False, stdout=subprocess.PIPE)/g' /usr/local/lib/python3.9/site-packages/img2table/ocr/tesseract.py
ENV NUMBA_CACHE_DIR=/tmp/numba_cache
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
RUN mv ./config.json /app && chmod a+w /app/config.json
