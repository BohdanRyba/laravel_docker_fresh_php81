#!/bin/bash

envsubst '$$PHP_HOST $$PHP_PORT $$PHP_HOST_XDEBUG $$PHP_PORT_XDEBUG' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

for string in $DOMAINS
do
    set -f
    array=(${string//=/ })
    for i in "${!array[@]}"
    do
        if [ $i == 0 ]
        then
            export VAR_VIRTUAL_HOST=${array[i]}
        else
            export VAR_MAGE_RUN_CODE=${array[i]}
        fi
    done

    export VAR_MAGE_MODE=${MAGE_MODE}
    export VAR_MAGE_ROOT=${MAGE_ROOT}
    export VAR_MAGE_RUN_TYPE=${MAGE_RUN_TYPE}
    envsubst '$$VAR_VIRTUAL_HOST $$VAR_MAGE_MODE $$VAR_MAGE_ROOT $$VAR_MAGE_RUN_CODE $$VAR_MAGE_RUN_TYPE' < /etc/nginx/conf.d/subdomain.template > /etc/nginx/conf.d/subdomains/${VAR_VIRTUAL_HOST}.conf
done
