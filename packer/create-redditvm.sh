#!/bin/bash

if [[ $1  ]]; then
    gcloud compute instances create $1 --image=reddit-full-1540142482 --tags puma-server --metadata-from-file startup-script=/home/tgz/revard_infra/packer/scripts/startup_script.sh
else
    echo "Argument error: need VM name"
fi
