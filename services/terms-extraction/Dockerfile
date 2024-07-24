FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.10

USER root

RUN apt-get update && apt-get install -y locales

# Génère la locale en_US.UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

# Configure la locale par défaut
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install all python dependencies
RUN pip install \
    --index-url https://download.pytorch.org/whl/cpu \
    --extra-index-url https://pypi.org/simple \
    numpy==1.26.3 \
    CQE==2.0.2 \
    scikit-learn==1.2.2 \
    stemming==1.0.1

# Install all node dependencies
RUN npm install \
    @ezs/teeft@2.3.1 \
    @ezs/strings@1.0.3

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
