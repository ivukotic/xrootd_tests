kubectl create namespace aaas

echo "Adding x509 cert needed for data access"
kubectl delete secret -n aaas x509-secret
kubectl create secret -n aaas generic x509-secret --from-file=userkey=secrets/xcache.key.pem --from-file=usercert=secrets/xcache.crt.pem

kubectl create -f tester-cron.yaml

