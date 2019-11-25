# xrootd_tests
Testing ATLAS xrootd endpoints

There are two tests:
* working of accessibility of files in DDM endpoints via xrootd doors. 
* working of xcache servers.

Tests are running once per hour in a k8s cron jobs.
Rucio is giving addresses to be used.
Results are reported to Elasticsearch at UC. 
