#!/bin/bash

# parses anchor peers for an organization from configtx.yaml, 
# attaches it to config.json and writes output to updated_config.json

if test "$#" -ne 4; then
   echo "usage: attach_anchor_peers.sh <orgID> <configtx.yaml> <config.json> <updated_config.json>" 
   exit 2
fi

# switch to caller directory so we can work with relative paths
cd $(pwd)

# exit when any command fails
set -e
# set -x

orgID=$1
configtx_yaml=$2
config_json=$3
updated_config_json=$4
workdir="/tmp"

# parse AnchorPeers from configtx.yaml
anchor_peers=$(yq -c  '.Organizations[] | select (.Name == "'$(echo $orgID)'") | .AnchorPeers' "$configtx_yaml")
if [ -z "$anchor_peers" ]; then
   echo "-- couldn't parse AnchorPeers for organization $orgID from $configtx_yaml" 
   exit 1
fi

echo "-- parsed AnchorPeers for organization $orgID from $configtx_yaml: $anchor_peers"

# convert keys to lower case in AnchorPeers
anchor_peers=$(echo "$anchor_peers" | jq -c '.[] | with_entries(.key |=ascii_downcase)' | jq -cs .)
echo "-- converted keys in AnchorPeers to lower case: $anchor_peers"

jq '.channel_group.groups.Application.groups.'$(echo $orgID)'.values += 
        {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": '$(echo $anchor_peers)'},"version": "0"}}' \
        "$config_json" > "$updated_config_json"
echo "-- attached anchor peers for organization $orgID and wrote to $updated_config_json"


