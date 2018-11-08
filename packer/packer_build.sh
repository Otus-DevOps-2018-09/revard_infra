#~/bin/bash

packer build -var-file=variables.json  ./immutable.json
