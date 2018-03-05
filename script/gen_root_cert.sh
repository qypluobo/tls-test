#!/bin/sh

echo "----------------"
echo "Creating self-signed root CA certificate"
echo "----------------"

read -p "Enter your domain [www.example.com]: " DOMAIN

echo "Create self-signed root CA key..."

openssl genrsa -des3 -out $DOMAIN.key 1024

echo "Create root CA certificate signing request..."

SUBJECT="/C=US/ST=Mars/L=iTranswarp/O=iTranswarp/OU=iTranswarp/CN=$DOMAIN"

openssl req -new -subj $SUBJECT -key $DOMAIN.key -out $DOMAIN.csr

echo "Remove password..."

mv $DOMAIN.key $DOMAIN.origin.key
openssl rsa -in $DOMAIN.origin.key -out $DOMAIN.key

echo "Sign SSL certificate..."

openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.pem
