#!/bin/bash
# vars
DOCKER_NAME="snx-dante"
DOCKER_SOURCE="mnasiadka/snx-dante"
SNX_USER="EDITME"
SNX_SERVER="EDITME"

while [[ $# -gt 0 ]]
do
key=$1

case $key in
    -l|--logs)
    	LOGS="1"
    	shift # past argument
    ;;
    -b|--browser)
    	BROWSER="1"
    	shift # past argument
    ;;
    -h|--help)
	echo "Usage: --logs (shows docker logs after run) --browser (runs browser pointing to socks5)"
	exit 0
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

IFS= read -s  -p "SNX Password:" pwd
echo -e "\n" 

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

if [ "$LOGS" ]; then
	echo "LOGS:"
	docker logs $DOCKER_NAME
fi
