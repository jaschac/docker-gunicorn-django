FROM debian:latest
MAINTAINER Jascha Casadio "jascha@lostinmalloc.com"
RUN apt-get update
RUN apt-get install -y -qq python python-pip
RUN pip install gunicorn django python-memcached
ADD scripts/setup.sh /lostinmalloc/scripts/setup.sh
WORKDIR /lostinmalloc/scripts
CMD sh setup.sh
