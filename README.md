# gunicorn-django
#### Table of Contents
1. [Overview](#overview)
2. [Image Description](#image-description)
3. [Setup](#setup)
    * [Pulling from the Docker Hub](#pulling-from-the-docker-hub)
    * [Building the Image from the Source](#building-the-image-from-the-source)
        * [The Dockerfile](#the-dockerfile)
        * [The setup.sh](#the-setup.sh)
4. [Usage](#usage)
    * [Docker Compose](#docker-compose)
5. [Limitations](#limitations)
6. [Development](#development)
    * [To do](#to-do)

### Overview
This image deploys a Gunicorn Web Server Gateway Interface HTTP Server serving a Django web application. It allows the client to customize both the number of workers to fire up and the port to listen to.

### Image Description
The gunicorn-django image is responsible of:

 1. Deploying a Gunicorn WSGI Server.
 2. Firing up workers ready to serve any HTTP request made to the Django web application being served, through an arbitrary port, which defaults to 8001.

A container running the gunicorn-django image will:

 1. Check if a volume containing a Django web application has been added to /var/www/webapp.
 2. Find the name of Django web application present at /var/www/webapp.
 3. Fire up N workers serving the web application, listening to an arbitrary port, which defaults to 8001.

### Setup
There are two ways to get and use the gunicorn-django image to create containers:

#### Pulling from the Docker Hub
 1. Pulling it from the Docker Hub.

#### Building the Image from the Source
gunicorn-django's source code can be freely pulled from Github, modified and used to build the image.

```bash
    $ git clone <GIT REPO> gunicorn-django
```
 
 Once pulled, the image will have the following structure:
```bash
    gunicorn-django/
    ├── Dockerfile
    ├── LICENSE
    ├── metadata.json
    ├── README.md
    └── scripts
        └── setup.sh
```

The image can be built with the following command(s):

```bash
    $ sudo docker build -t gunicorn -f $PWD/gunicorn-django/Dockerfile $PWD/gunicorn-django
    Successfully built 8ecf91a49000
    $ sudo docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    gunicorn            latest              8ecf91a49000        13 seconds ago      380.1 MB
```

#### The Dockerfile
@TODO

#### The setup.sh
@TODO


## Usage
The gunicorn-django does expect the following information to be provided by the client:

 * A **directory** containing a Django web application. This directory should be shared at the root level, that is, were the manage.py file is. It is expected to be provided as a (read only) volume pointing at /var/www/webapp/.

The following optional parameters can be also provided to a container:

 * A **port** that GUnicorn will be listening to. This defaults to 8001. It must be provided as the $GUNICORN_PORT environment variable.
 * The **number of workers** GUnicorn will fire up. It defaults to 2. It must be provided as the $GUNICORN_WORKERS environment variable.

In the following example we do assume to have this scenario:
```bash
$ tree -d
.
├── images
│   └── gunicorn-django
└── volumes
    └── django
        └── djsonizer
```

We can fire up a gunicorn-django container and expose port 8001 to the host to test it.
```bash
$ sudo docker run -p 8001:8001 -v $PWD/volumes/django/djsonizer/:/var/www/webapp:ro -d gunicorn
87680bcf0d77e35c3ed04dacbd88700707b3a886b606265b6c92a0c2878ae4fa

$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
87680bcf0d77        gunicorn            "/bin/sh -c 'sh setup"   12 seconds ago      Up 11 seconds       0.0.0.0:8001->8001/tcp   tender_morse

$ sudo docker inspect 87680bcf0d77 | grep -e \"IPAddress\"
"IPAddress": "172.17.0.10",

$ curl 172.17.0.10:8001/hello/
{"cached": false, "word": "hello", "len": 5, "cached_by": ""}
```

#### Docker Compose
We can fire up a multi-container application based on gunicorn-django and the official memcached:latest image available on the Hub through Docker Compose.


1) Create a docker-compose.yml file.
```bash
    gunicorn:
      image: gunicorn:latest
      links:
        - memcached:memcached
      ports:
        - "8001:8001"
      volumes:
        - /home/jascha/projects/docker/volumes/django/djsonizer/:/var/www/webapp:ro
    memcached:
      image: memcached:latest
      ports:
        - "11211:11211"
```

2) Fire the multi-container application up.
```bash
    $ sudo docker-compose up -d
    Creating images_memcached_1
    Creating images_gunicorn_1
    
    $ sudo docker-compose ps
           Name                  Command            State            Ports           
    --------------------------------------------------------------------------------
    images_gunicorn_1    /bin/sh -c sh setup.sh     Up      0.0.0.0:8001->8001/tcp   
    images_memcached_1   /entrypoint.sh memcached   Up      0.0.0.0:11211->11211/tcp
    
    $ sudo docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                      NAMES
    251f79f3b690        gunicorn:latest     "/bin/sh -c 'sh setup"   About a minute ago   Up About a minute   0.0.0.0:8001->8001/tcp     images_gunicorn_1
    ee09a2c847c7        memcached:latest    "/entrypoint.sh memca"   About a minute ago   Up About a minute   0.0.0.0:11211->11211/tcp   images_memcached_1
```

3) Test the application.
```bash
    $ sudo docker inspect 251f79f3b690 | grep -e \"IPAddress\"
    "IPAddress": "172.17.0.9",
    
    $ curl 172.17.0.9:8001/hello/
    {"cached": false, "word": "hello", "len": 5, "cached_by": ""}
    $ curl 172.17.0.9:8001/foo/
    {"cached": false, "word": "foo", "len": 3, "cached_by": ""}
    $ curl 172.17.0.9:8001/hello/
    {"cached": true, "word": "hello", "len": 5, "cached_by": {"ip": "172.17.0.9", "hostname": "251f79f3b690"}}
```

4) Clean it all up.
```bash
    $ sudo docker-compose stop
    Stopping images_gunicorn_1 ... 
    Stopping images_gunicorn_1 ... done
```

## Limitations
At the very moment the image does not allow the client to provide the container neither the number of workers nor the port that GUnicorn should be listening for connections to. Both are optional and should be provided by the client through environment variables. The former defaults to 2, while the latter to 8001.


## Development
This module has been developed and tested on the following setup(s):

*Operating Systems*:

 - Debian 8 Jessie (3.16.7-ckt11-1+deb8u5 x86_64)

*Docker*

 - 1.8.3_f4bf5c7

*Docker Componse*

 - Not tested, yet.


#### To do

 * Add support for an environment variable that allows the client to define the number of workers and that defaults to 2
 * Add support for an environment variable that allows the client to define the port GUnicorn will listen to. It defaults to 8001.
