# revard_infra

bastion_IP = 35.189.211.216

someinternalhost_IP = 10.132.0.3

testapp_IP = 35.195.127.189

testapp_port = 9292 

### Instalation and use
 
Packer configs in directory packer.

All scripts in directory packer/scripts.

User commands bellow to get full installed image adn VM fo puma server.

### Commands for create immutable template by pxacker
```
$ > packer validate -var-file=variables.json immutable.json
$ > packer build -var-file=variables.json immutable.json
...
```

### Command for create VN for gcloud
```
$ > gcloud compute instances create packer-systemd-test5 --tags=puma-server  --image-family reddit-full
```

### Script for automation
$ > create-redditvm.sh
