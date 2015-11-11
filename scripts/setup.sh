#!/bin/bash
#
# Initializes a gunicorn-django container
#

set -e

WWW_ROOT_DIR=/var/www/webapp

# Initialize the workers
[[ -z $WEB_APP_WORKERS ]] && WORKERS=2 || WORKERS=$WEB_APP_WORKERS

# Initialize the port
[[ -z $WEB_APP_PORT ]] && PORT=8001 || PORT=$WEB_APP_PORT

# Make sure the webapp directory exists
if [ -d $WWW_ROOT_DIR ] && [ "$(ls -A $WWW_ROOT_DIR)" ]
then
	cd $WWW_ROOT_DIR
	WEB_APP=$(find * -maxdepth 0 -type d)
	gunicorn $WEB_APP.wsgi:application -w $WORKERS --bind=0.0.0.0:$PORT
else
	exit 1
fi
