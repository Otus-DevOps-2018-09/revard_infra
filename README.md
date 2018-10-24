# revard_infra

bastion_IP = 35.189.211.216

someinternalhost_IP = 10.132.0.3

testapp_IP = 35.198.167.169

testapp_port = 9292 

testapp_IP = 35.195.127.189

testapp_port = 9292 

### Instalation and use
 
Packer configs in directory packer.

All scripts in directory packer/scripts.

User commands bellow to get full installed image adn VM fo puma server.

### Commands for create immutable template by pxacker
```
tgz @ alf-server ~/revard_infra/packer (packer-base)
└─ $ > packer validate -var-file=variables.json immutable.json
Template validated successfully.
tgz @ alf-server ~/revard_infra/packer (packer-base)
└─ $ > packer build -var-file=variables.json immutable.json
googlecompute output will be in this color.

==> googlecompute: Checking image does not exist...
==> googlecompute: Creating temporary SSH key for instance...
==> googlecompute: Using image: ubuntu-1604-xenial-v20181023
==> googlecompute: Creating instance...
...
```

### Command for create VN for gcloud
```
tgz @ alf-server ~/revard_infra/packer (packer-base)
└─ $ > gcloud compute instances create packer-systemd-test5 --tags=puma-server  --image-family reddit-full
Created [https://www.googleapis.com/compute/v1/projects/infra-219211/zones/europe-west1-b/instances/packer-systemd-test5].
NAME                  ZONE            MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
packer-systemd-test5  europe-west1-b  n1-standard-1               10.132.0.6   35.195.234.157  RUNNING
```
