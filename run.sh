#!/bin/bash
USE_ELASTICSEARCH=false
FOLDER=''
while [ -n "$1" ]; do # while loop starts
	case "$1" in
	-es) USE_ELASTICSEARCH=true ;;
	-f)
		FOLDER="$2"
		shift
		;;
	--)
		shift # The double dash makes them parameters
		break
		;;
	*) echo "Option $1 not recognized" ;;
	esac
	shift
done

if [ ! -d $FOLDER ]; then
	echo "Folder $FOLDER is not exist"
	exit 1;
fi

cd $FOLDER
docker-compose $1 $2 $3 $4

if [ $1 == 'up' ]; then
	BASE_URL=`docker-compose exec -T magento printenv BASE_URL`
	COUNT_LIMIT=720
	while ! RESPONSE=`curl -s ${BASE_URL}magento_version`
	do
	    if [ $COUNT_LIMIT -lt 1 ]; then
	        break
	    fi
	    COUNT_LIMIT=$(( COUNT_LIMIT - 1 ))
	    sleep 5
	done

	if [[ -z "${RESPONSE}" || ${RESPONSE:0:8} != "Magento/" ]]; then
	    echo 'Build magento failed!'
	    exit 1
	fi
	if [ $USE_ELASTICSEARCH = true ]; then
		docker-compose exec -u www-data -T magento bash -c \
	        "php bin/magento config:set catalog/search/engine elasticsearch7 ; \
	        php bin/magento config:set catalog/search/elasticsearch7_server_hostname elasticsearch ; \
	        php bin/magento cache:clean config full_page ; \
	        php bin/magento indexer:reindex ; \
	        php bin/magento cache:clean full_page "
    else
    	docker-compose exec -u www-data -T magento bash -c \
	        "php bin/magento config:set catalog/search/engine mysql ; \
	        php bin/magento cache:clean config full_page ; \
	        php bin/magento indexer:reindex ; \
	        php bin/magento cache:clean full_page "
    fi

    echo ""
    echo "Build Magento successfully!!"
fi