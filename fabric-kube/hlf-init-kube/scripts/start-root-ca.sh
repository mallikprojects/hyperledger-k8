#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Initialize the root CA
fabric-ca-server init --ca.certfile $MY_CA_CERTFILE --ca.keyfile $MY_CA_KEYFILE -b $BOOTSTRAP_USER_PASS

#persist CA files so that they can be used later
cp $FABRIC_CA_HOME/ca-cert.pem  $MY_CA_CERTFILE
cp $FABRIC_CA_HOME/ca-key.pem   $MY_CA_KEYFILE

# Copy the root CA's signing certificate to the data directory to be used by others
#cp $FABRIC_CA_HOME/ca-cert.pem $TARGET_CERTFILE

# Add the custom orgs
for o in $FABRIC_ORGS; do
   aff=$aff"\n   $o: []"
done
aff="${aff#\\n   }"
sed -i "/affiliations:/a \\   $aff" \
   $FABRIC_CA_HOME/fabric-ca-server-config.yaml

# Start the root CA
fabric-ca-server start
