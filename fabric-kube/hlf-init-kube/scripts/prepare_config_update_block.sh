#!/bin/bash

# takes config.json and updated_config.json as inputs
# calculate a config update, wraps in enveleope and convert to protobuf format
# the resulting output block is ready for `peer channel update`

if test "$#" -ne 4; then
   echo "usage: prepare_config_update_block.sh <channelID> <config.json> <updated_config.json> <output_block>" 
   exit 2
fi

# switch to caller directory so we can work with relative paths
cd $(pwd)

# exit when any command fails
set -e
# set -x

channelID=$1
config_json=$2
updated_config_json=$3
output_block=$4
workdir="/tmp"

# convert config.json and updated_config.json to protobuf
configtxlator proto_encode --input "$config_json" --type common.Config --output $workdir/config.pb
echo "-- converted $config_json to protobuf"
configtxlator proto_encode --input "$updated_config_json" --type common.Config --output $workdir/updated_config.pb
echo "-- converted $updated_config_json to protobuf"

# calculate compute_update
configtxlator compute_update --channel_id $channelID --original $workdir/config.pb --updated $workdir/updated_config.pb --output $workdir/config_update.pb
echo "-- calculated compute_update and wrote to config_update.pb"

# convert config_update.pb to json
configtxlator proto_decode --input $workdir/config_update.pb --type common.ConfigUpdate | jq . > $workdir/config_update.json
echo "-- converted config_update.pb to json"

# wrap in envelope
echo '{"payload":{"header":{"channel_header":{"channel_id":'$(echo \"$channelID\")', "type":2}},"data":{"config_update":'$(cat $workdir/config_update.json)'}}}' \
        | jq . > $workdir/config_update_in_envelope.json
echo "-- wrapped config_update.json in envelope"

# convert to protobuf
configtxlator proto_encode --input $workdir/config_update_in_envelope.json --type common.Envelope --output "$output_block"
echo "-- wrote final protobuf to $output_block"

