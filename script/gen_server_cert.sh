#!/bin/sh

echo "----------------"
echo "Creating server certificate which is signed by root CA"
echo "----------------"

read -p "Enter your domain [www.example.com]: " DOMAIN

echo "Create server key..."

openssl genrsa -des3 -out $DOMAIN.key 1024

echo "Create server certificate signing request..."

SUBJECT="/C=US/ST=Mars/L=iTranswarp/O=iTranswarp/OU=iTranswarp/CN=$DOMAIN"

openssl req -new -subj $SUBJECT -key $DOMAIN.key -out $DOMAIN.csr

echo "Remove password..."

mv $DOMAIN.key $DOMAIN.origin.key
openssl rsa -in $DOMAIN.origin.key -out $DOMAIN.key

echo "Sign SSL certificate..."

#openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.pem
#openssl x509 -req -days 365 -sha1 -extensions v3_req -CA certs/ca.cer -CAkey private/cakey.pem -CAserial ca.srl -CAcreateserial -in private/server.csr -out certs/server.cer

openssl x509 -req -days 365 -CA rootca.pem -CAkey rootca.key -CAserial rootca.srl -CAcreateserial -in $DOMAIN.csr -out $DOMAIN.pem
