#!/bin/bash

if [[ $1  ]]; then
	packer validate -var-file=variables.json immutable.json &&  packer build -var-file=variables.json immutable.json
	gcloud compute instances create $1 --tags=puma-server  --image-family reddit-full
else
    echo "Argument error: need VM name"
fi
