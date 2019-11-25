#!/bin/sh

# sleep until x509 things set up.
export X509_USER_PROXY=/etc/proxy/x509up
while [ ! -f $X509_USER_PROXY ]
do
  sleep 10
  echo "waiting for x509 proxy."
done
ls $X509_USER_PROXY


python xroot_test.py

