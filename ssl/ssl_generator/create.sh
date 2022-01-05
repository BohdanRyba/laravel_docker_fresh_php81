#!/bin/bash 

cd $(dirname $0)

if [ -z "$1" ]
then
  echo "Please supply a subdomain to create a certificate for";
  echo "e.g. mysite.localhost"
  exit;
fi

mkdir -p out

if [ -f out/device.key ]; then
  KEY_OPT="-key"
else
  KEY_OPT="-keyout"
fi

DOMAIN=$1
COMMON_NAME=${2:-$1}

SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=$COMMON_NAME"
NUM_OF_DAYS=360

openssl req -new -newkey rsa:2048 -sha256 -nodes $KEY_OPT out/device.key -subj "$SUBJECT" -out out/device.csr

cat v3.ext | sed s/%%DOMAIN%%/$COMMON_NAME/g > /tmp/__v3.ext

openssl x509 -req -in out/device.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out out/device.crt -days $NUM_OF_DAYS -sha256 -extfile /tmp/__v3.ext

mkdir -p ../$DOMAIN

mv out/device.csr ../$DOMAIN/$DOMAIN.csr
mv out/device.crt ../$DOMAIN/$DOMAIN.crt
cp out/device.key ../$DOMAIN/$DOMAIN.key

# remove temp file
#rm -f device.crt;
