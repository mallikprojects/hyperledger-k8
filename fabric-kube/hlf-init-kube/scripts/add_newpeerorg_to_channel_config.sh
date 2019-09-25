#!/bin/bash

# adds new peer org to given channel config.json and writes output to updated_config.json

if test "$#" -ne 4; then
   echo "usage: add_newpeerorg_to_channel_config.sh <orgID> <neworg.json> <config.json> <updated_config.json>" 
   exit 2
fi

# switch to caller directory so we can work with relative paths
cd $(pwd)

# exit when any command fails
set -e
# set -x

orgID=$1
neworg_json=$2
config_json=$3
updated_config_json=$4

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"'$(echo $orgID)'":.[1]}}}}}' "$config_json" "$neworg_json" > "$updated_config_json"
echo "-- attached new peer organization $orgID and wrote to $updated_config_json"


