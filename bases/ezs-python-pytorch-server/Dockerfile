FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

ARG torch_ver=2.3.0
ARG torchvision_ver=0.18.0
ARG torchaudio_ver=2.3.0

WORKDIR /app

USER root

# Install build depenencies
RUN apt update && apt install -y build-essential make gcc

# Install pytorch
# We use the default repository as fallback to other package,
# it not required but if we want to add other module not
# avaible in pytorch repository this make it possible.
RUN pip install --no-build-isolation \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    torch==${torch_ver} \
    torchvision==${torchvision_ver} \
    torchaudio==${torchaudio_ver}

# Clean-up
RUN apt remove -y --purge build-essential make gcc && \
    apt autoremove -y

RUN chown daemon:daemon -R /app
