# Otus devops course

## HW-3 Bastion

bastion_IP = 35.189.211.216

someinternalhost_IP = 10.132.0.3

### One command connect to someinternalhost
```
tgz@alf-server:~$ ssh  -i ~/.ssh/appuser -A -t appuser@35.189.211.216 "ssh  10.132.0.3"
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-1021-gcp x86_64)
...
Last login: Sun Oct 14 13:51:22 2018 from 10.132.0.2
appuser@someinternalhost:~$ logout
```

### Setup ssh alias
```
Host bastion
  User appuser
  IdentityFile ~/.ssh/appuser
  Hostname 35.189.211.216

Host someinternalhost
  HostName 10.132.0.3
  Port 22
  User appuser
  ProxyCommand ssh -q -W %h:%p bastion
```
Test
```
tgz @ alf-server ~/revard_infra (cloud-bastion)
└─ $ > ssh someinternalhost
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-1021-gcp x86_64)
...
Last login: Mon Oct 15 18:20:22 2018 from 10.132.0.2
appuser@someinternalhost:~$
```

### Setup SSL key and it works :) 

Check by https://35.189.211.216.sslip.io/login

## HW-4 Cloud test

testapp_IP = 35.195.127.189

testapp_port = 9292 

### Startup script
```
#!/bin/bash

echo "----- Installing ruby! -----"
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

echo "----- Installing MongoDB! -----"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" >  /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org

echo "----- Starting MongoDB! ------"
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

echo "----- Deploying application! ------"
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma
```

### Gcloud command add firewall rule
```
gcloud compute firewall-rules create default-puma-server \
    --network default \
    --action allow \
    --direction ingress \
    --rules tcp:9292 \
    --source-ranges 0.0.0.0/0 \
    --priority 1000 \
    --target-tags puma-server
```

## HW-5 Packer base

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
```
$ > create-redditvm.sh
```

## HW-6 Terraform -1 

Creater config for deploying reddit servers and load balancer

Be aware with prameters when using multiple instances. 

Example of output after first initialization:

```
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

app_balancer_ip = 35.187.84.1xx
app_external_ip = [
    35.241.143.xx,
    35.195.140.xx
]
```

After initialization, we can see all resouses:
```
$ > terraform apply
google_compute_project_metadata.ssh_keys: Refreshing state... (ID: common_metadata)
google_compute_http_health_check.basic-check: Refreshing state... (ID: basic-check)
google_compute_firewall.firewall_puma: Refreshing state... (ID: allow-puma-default)
google_compute_instance.app[0]: Refreshing state... (ID: reddit-app-0)
google_compute_instance.app[1]: Refreshing state... (ID: reddit-app-1)
google_compute_target_pool.www-network-lb: Refreshing state... (ID: www-network-lb)
google_compute_forwarding_rule.www-rule: Refreshing state... (ID: www-rule)

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

app_balancer_ip = 35.187.84.1xx
app_external_ip = [
    35.241.143.xx,
    35.195.140.xx
]
```

## HW-7 Terraform-2

### Create modules
Make dirs for modules and load modules. Dont forget about variables.
```
$ terraform get
- module.app
  Getting source "modules/app"
- module.db
  Getting source "modules/db"
```

Can see tree
```
 tree .terraform
.terraform
├── modules
│   ├── a9aa53bac9b6b12943ed0fbaf231f446 -> /home/appuser/revard_infra/terraform/modules/db
│   ├── d52edfb6d63db99f07875dd8b80211c3 -> /home/appuser/revard_infra/terraform/modules/app
│   └── modules.json
└── plugins
    └── linux_amd64
        ├── lock.json
        └── terraform-provider-google_v1.4.0_x4

5 directories, 3 files
```
### Create enviroments
Make env dirs (stage and prod) and config files in it.
Go to ech dir end run
```
$ terraform init
...
$ terraform plan
...
```
