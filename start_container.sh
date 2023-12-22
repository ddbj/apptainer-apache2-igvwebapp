#!/bin/bash

CONTAINER_HOME=$(cd $(dirname $0); pwd)
CONTAINER="apache_igvwebapp"
IMAGE="ubuntu-20.04-apache-2.4-igv-webapp-1.13.sif"

if [ ! -e ${CONTAINER_HOME}/htdocs ]; then
    mkdir ${CONTAINER_HOME}/htdocs
fi

if [ ! -e ${CONTAINER_HOME}/cgi-bin ]; then
    mkdir ${CONTAINER_HOME}/cgi-bin
fi

if [ ! -e ${CONTAINER_HOME}/logs ]; then
    mkdir ${CONTAINER_HOME}/logs
fi

if [ ! -e ${CONTAINER_HOME}/${IMAGE} ]; then
    if [ -e /lustre7/software/experimental/igv-webapp/${IMAGE} ]
        cp /lustre7/software/experimental/igv-webapp/${IMAGE} ./
        cp /lustre7/software/experimental/igv-webapp/sample_file/* htdocs/
    fi
fi

apptainer instance start \
-B ${CONTAINER_HOME}/httpd.conf:/usr/local/apache2/conf/httpd.conf \
-B ${CONTAINER_HOME}/logs:/usr/local/apache2/logs \
-B ${CONTAINER_HOME}/htdocs:/usr/local/apache2/htdocs \
-B ${CONTAINER_HOME}/cgi-bin:/usr/local/apache2/cgi-bin \
-B ${CONTAINER_HOME}/package.json:/usr/local/src/igv-webapp/package.json \
-B ${CONTAINER_HOME}/start.sh:/usr/bin/start.sh \
${CONTAINER_HOME}/${IMAGE} \
${CONTAINER}

apptainer exec instance://${CONTAINER} /usr/local/apache2/bin/apachectl start
apptainer exec instance://${CONTAINER} /usr/bin/start.sh 1>> igv-webapp.log 2>> igv-webapp.log &
