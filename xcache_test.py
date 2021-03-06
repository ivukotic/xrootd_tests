#!/usr/bin/env python

# TESTING that XCACHE endpoints work
# first deletes the file from cache
# tries to cache it
# deletes it again.
# reports to ES.

import sys
import os
import time
from datetime import datetime
import tools

print('starting...')

if os.environ.get("RUCIO_ACCOUNT") != None:
    rucio_account = os.environ.get("RUCIO_ACCOUNT")
else:
    print("no RUCIO_ACCOUNT environment found. Please set it before using this program.")
    sys.exit(1)

endpoints = tools.getXCACHEendpoints()

origin = 'root://fax.mwt2.org:1094//pnfs/uchicago.edu/atlasdatadisk/rucio/mc15_13TeV/6a/54/HITS.06828093._000096.pool.root.1'
filename = 'mc15_13TeV/6a/54/HITS.06828093._000096.pool.root.1'

docs = []
for site, endpoint in endpoints.items():
    print('------------------------------------------------------------')
    doc = {'_index': 'testing_xrootd', 'site': site, 'issues': [], 'endpoint': endpoint, 'type': 'xcache'}
    print('Site:', site, 'address:', endpoint)
    docs.append(doc)

print('creating script to execute')

ts = datetime.utcnow().strftime("%Y%m%dT%H0000Z")
logpostfix = '_' + ts + '.log'
redstring = ' - 2>&1 >/dev/null | cat >'

try:
    with open('checkXcaches.sh', 'w') as f:
        for d in docs:
            d['timestamp'] = ts
            logfile = d['site'] + logpostfix

            # first remove from xcache
            rem = 'xrdfs ' + d['site'] + ' unlink ' + filename

            cpcomm = 'timeout 270 xrdcp -d 2 -f -np '
            comm = cpcomm + origin + redstring + logfile + ' & \n'
            f.write('echo "command executed:\n ' + comm + '" >> ' + logfile + '\n')
            f.write('echo "========================================================================" >> ' + logfile + '\n')
            f.write(comm)
        f.close()
except:
    print("Unexpected error:", sys.exc_info()[0])
# sys.exit(0)

print('executing all of the xrdcps in parallel. 5 min timeout.')
com = tools.Command("source ./checkXcaches.sh")
com.run(300)
time.sleep(250)


print('checking log files')

# checking which sites gave their own file directly
for d in docs:  # this is file to be asked for
    logfile = d['site'] + logpostfix
    try:
        with open(logfile, 'r') as f:
            lines = f.readlines()
            succ = False
            for l in lines:
                # print l
                if tools.isMsgOK(l):
                    succ = True
                    break
            if succ == True:
                print logfile, "works"
                d['state'] = "Works"
            else:
                print logfile, "problem"
                d['state'] = "problem"
    except:
        print "Unexpected error:", sys.exc_info()[0]


tools.storeInES(docs)

print('All done.')
