#!/bin/bash
# vars
DOCKER_NAME="snx-dante"
DOCKER_SOURCE="mnasiadka/snx-dante"
SNX_USER="EDITME"
SNX_SERVER="EDITME"

IFS= read -s  -p SNX Password: pwd

if [ "$(docker ps -aq -f status=running -f name=$DOCKER_NAME)" ]; then
	echo -ne "$DOCKER_NAME is running, stopping... "
	docker stop $DOCKER_NAME
	echo "done"
fi
if [ "$(docker ps -aq -f status=exited -f name=$DOCKER_NAME)" ]; then
	echo -ne "$DOCKER_NAME is not running, removing stale container... "
        docker rm $DOCKER_NAME
	echo "done"
fi
echo -ne "Starting $DOCKER_NAME..."
docker run -p 127.0.0.1:1080:1080 --cap-add=ALL -v /lib/modules:/lib/modules -v /dev:/dev -e SNX_PASSWORD=$pwd -e SNX_USER=$SNX_USER -e SNX_SERVER=$SNX_SERVER --name snx-dante -d -ti $DOCKER_SOURCE
echo "done"
fi
