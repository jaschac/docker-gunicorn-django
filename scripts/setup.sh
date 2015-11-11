#!/bin/bash

set -e

WWW_ROOT_DIR=/var/www/webapp

if [ -d $WWW_ROOT_DIR ]
then
	cd $WWW_ROOT_DIR
	WEB_APP=$(find * -maxdepth 0 -type d)
	if [ -d $WEB_APP ]
	then
		gunicorn $WEB_APP.wsgi:application -w 2 --bind=0.0.0.0:8001
	fi
fi
