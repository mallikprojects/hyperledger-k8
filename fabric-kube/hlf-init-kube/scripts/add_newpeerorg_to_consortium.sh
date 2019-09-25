#!/bin/bash

# adds new peer org to list of consortiums in given system channel config.json and writes output to updated_config.json

if test "$#" -ne 5; then
   echo "usage: add_newpeerorg_to_consortium.sh <orgID> <consortium> <neworg.json> <config.json> <updated_config.json>" 
   exit 2
fi

# switch to caller directory so we can work with relative paths
cd $(pwd)

# exit when any command fails
set -e
# set -x

orgID=$1
consortium=$2
neworg_json=$3
config_json=$4
updated_config_json=$5

jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"'$(echo $consortium)'": {"groups": {"'$(echo $orgID)'":.[1]}}}}}}}' "$config_json" "$neworg_json" > "$updated_config_json"
echo "-- attached new peer organization $orgID to consortium $consortium and wrote to $updated_config_json"


