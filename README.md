# gunicorn-django
#### Table of Contents
1. [Overview](#overview)
2. [Image Description](#image-description)
3. [Setup](#setup)
    * [Pulling from the Docker Hub](#pulling-from-the-docker-hub)
    * [Building the image](#building-the-image)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

### Overview
This image deploys a Gunicorn Web Server Gateway Interface HTTP Server serving a Django web application. By default it fires up 2 workers and listens to port 8001, which is exposed to the host.

### Image Description
The gunicorn-django image is responsible of: 

 1. Deploying a Gunicorn WSGI Server.
 2. Firing up workers ready to serve any HTTP request made to the Django web application being served, through port 8001.

By default a container run using the gunicorn-django image will:

 1. This
 2. That
 3. and that!

### Setup
There are two ways to get and use the gunicorn-django image to create containers:

#### Pulling from the Docker Hub
 1. Pulling it from the Docker Hub.

```bash
    $ ADD ME
    $ ADD ME
```

#### Building the image
gunicorn-django's source code can be freely pulled from Github, modified and used to build the image.
```bash
    $ git clone <GIT REPO> .
```
 Once pulled, the image will have the following structure:
```bash
    gunicorn-django/
    ├── Dockerfile
    ├── LICENSE
    ├── metadata.json
    └── README.md
```
 The image can be built with the following command(s):

```bash
$ echo $PWD
/home/jascha/projects/docker
$ sudo docker build -t gunicorn -f $PWD/images/gunicorn-django/Dockerfile $PWD/images/gunicorn-django
Successfully built bf090f4d6cc0
```
Notice the last part of the command, where we define the build context, that is, the root directory used by Docker to build the gunicorn-django image. We want to make sure that it is, indeed, the gunicorn-django directory and not one of its parents.

## Usage

Running a container in interactive mode, with a bash shell ready to use:

```bash
ADD ME
```

## Reference
@TODO

## Limitations
The module has not been tested as a daemon yet. So far it works by running the container with an interactive bash shell and running gunicorn, then accessing it through curl. At the moment, the image automatically adapts to whatever name the Django web application is given, as long as it is server in /var/www/webapp/.

```bash
$ pwd
/home/jascha/projects/docker
$ sudo docker run --rm=true -p 8001:8001 -v $PWD/volumes/django/djsonizer/:/var/www/webapp:ro -ti gunicorn /bin/bash

root@89535735ba9a:/# cd /var/www/webapp
root@89535735ba9a:/var/www/webapp# webapp=$(find * -maxdepth 0 -type d)
root@89535735ba9a:/var/www/webapp# echo $webapp
djsonizer
root@89535735ba9a:/var/www/webapp# gunicorn $webapp.wsgi:application -w 2 --bind=127.0.0.1:8001 &
[2015-11-02 23:19:23 +0000] [449] [INFO] Starting gunicorn 19.3.0
[2015-11-02 23:19:23 +0000] [449] [INFO] Listening at: http://127.0.0.1:8001 (449)
[2015-11-02 23:19:23 +0000] [449] [INFO] Using worker: sync
[2015-11-02 23:19:23 +0000] [454] [INFO] Booting worker with pid: 454
[2015-11-02 23:19:23 +0000] [455] [INFO] Booting worker with pid: 455
root@89535735ba9a:/var/www/webapp# curl http://127.0.0.1:8001
{"cached": false, "word": "", "len": 0, "cached_by": {}}
```

## Development
This module has been developed and tested on the following setup(s):

*Operating Systems*:

 - Debian 8 Jessie (3.16.7-ckt11-1+deb8u5 x86_64)

*Docker*

 - 1.8.3_f4bf5c7

*Docker Componse*

 - Not tested, yet.





$ curl 172.17.0.8:8001
{"cached": false, "word": "", "len": 0, "cached_by": {}}jascha@docker:~/projects/docker$ 
jascha@docker:~/projects/docker$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
9551afcacce9        gunicorn            "/bin/sh -c 'sh setup"   About a minute ago   Up About a minute   0.0.0.0:8001->8001/tcp   kickass_tesla
udo docker run -p 8001:8001 -v $PWD/volumes/django/djsonizer/:/var/www/webapp:ro -d gunicorn
