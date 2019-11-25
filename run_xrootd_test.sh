#!/bin/sh

# sleep until x509 things set up.
export X509_USER_PROXY=/etc/grid-security/x509up
while [ ! -f $X509_USER_PROXY ]
do
  sleep 10
  echo "waiting for x509 proxy."
done
ls $X509_USER_PROXY


python xrootd_test.py

