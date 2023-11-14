FROM cnrsinist/ezs-python-server:py3.9-no20-1.0.0

USER pn
WORKDIR /app/public
RUN pip install unidecode==1.3.7
# Declare files to copy in .dockerignore
COPY . /app/public/
