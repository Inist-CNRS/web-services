FROM cnrsinist/ezs-python-server:py3.9-no16-1.0.6

USER root
# Install all python dependencies
# RUN pip install \
#     unidecode==1.3.7

# Install all node dependencies
RUN npm install \
    @ezs/libpostal@0.2.3 \
    @ezs/conditor@2.10.7

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY --chown=daemon:daemon . /app/public/
