FROM cnrsinist/ezs-python-server:py3.10-no24-2.0.5

WORKDIR /app
RUN pip install --no-cache-dir unidecode==1.3.7

WORKDIR /app/public
# Declare files to copy in .dockerignore
COPY . /app/public/
