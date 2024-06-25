FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

# Set all required version
ARG torch_ver=2.3.0
ARG torchvision_ver=0.18.0
ARG torchaudio_ver=2.3.0
ARG scipy_ver=1.10.1
ARG transformers_ver=4.41.2
ARG flair_ver=0.10

WORKDIR /app
USER root

#####
### Multi layer installation, this part is here to help understanding the
### monolayer installation below.
#####
## Install build depenencies
#RUN apt update && apt install -y build-essential make gcc
#
## Install pytorch, scipy, transformers and flair
## For the pip installation we use the default repository
## as fallback to other package,
## it not required but if we want to add other module not
## avaible in pytorch repository this make it possible.
#RUN pip install --no-build-isolation \
#    --index-url https://download.pytorch.org/whl/cpu \
#    --extra-index-url https://pypi.org/simple \
#    torch==${torch_ver} \
#    torchvision==${torchvision_ver} \
#    torchaudio==${torchaudio_ver} \
#    scipy==${scipy_ver} \
#    transformers==${transformers_ver} \
#    flair==${flair_ver}
#
## Clean-up
#RUN apt remove -y --purge build-essential make gcc && \
#    apt autoremove -y

# Install depencies, for documention see commented code above
RUN apt update && apt install -y build-essential make gcc && \
    pip install --no-build-isolation \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    torch==${torch_ver} \
    torchvision==${torchvision_ver} \
    torchaudio==${torchaudio_ver} \
    scipy==${scipy_ver} \
    transformers==${transformers_ver} \
    flair==${flair_ver} && \
    apt remove -y --purge build-essential make gcc && \
    apt autoremove -y

# Make sure that .flair folder is readable by the daemon user
WORKDIR /usr/sbin/.flair
RUN chmod -R a+rwx /usr/sbin/.flair

WORKDIR /app
# Create a cache directory
RUN mkdir /app/.cache

# Convert every file owner
RUN chown daemon:daemon -R /app

# Set the transformers cache directory
# ENV TRANSFORMERS_CACHE=/app/.cache/transformers # Old transformers cache directory environement variables
ENV HF_HOME=/app/.cache/transformers

EXPOSE 31976
# See .dockerignore to see what files are copied
COPY --chown=daemon:daemon . /app/
