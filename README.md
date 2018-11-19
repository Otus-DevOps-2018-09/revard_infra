# Otus devops course

## HW-11 Ansible-4
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-4)](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-4)

### Vagrant

#### Install VirtualBox and Vagrant 

In ansible dir where file Vagrantfile run command:
```
$ > vagrant up
Bringing machine 'dbserver' up with 'virtualbox' provider...
Bringing machine 'appserver' up with 'virtualbox' provider...
==> dbserver: Box 'ubuntu/xenial64' could not be found. Attempting to find and install...
    dbserver: Box Provider: virtualbox
    dbserver: Box Version: >= 0
...
```

#### Check status:
```
$ >  vagrant box list
ubuntu/xenial64 (virtualbox, 20181113.0.0)

$ >  vagrant status
Current machine states:

dbserver                  running (virtualbox)
appserver                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`
```

#### Check connection:
```
 $ >  vagrant ssh appserver 
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-138-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.

New release '18.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


vagrant@appserver:~$  ping -c 2 10.10.10.10 
PING 10.10.10.10 (10.10.10.10) 56(84) bytes of data.
64 bytes from 10.10.10.10: icmp_seq=1 ttl=64 time=1.33 ms
64 bytes from 10.10.10.10: icmp_seq=2 ttl=64 time=0.974 ms

--- 10.10.10.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1005ms
rtt min/avg/max/mdev = 0.974/1.155/1.336/0.181 ms
vagrant@appserver:~$ logout
Connection to 127.0.0.1 closed.
```

### Molecule

#### Install

Install molecule https://molecule.readthedocs.io/en/latest/installation.html

Recommended use  virtualenv for python https://docs.python-guide.org/dev/virtualenvs/

#### Init

```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $  molecule init scenario --scenario-name default -r db -d vagrant
--> Initializing new scenario default...
```

#### Create VM
```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $ molecule create
--> Validating schema /home/alf/revard_infra/ansible/roles/db/molecule/default/molecule.yml.
Validation completed successfully.
--> Test matrix

└── default
    ├── create
    └── prepare

--> Scenario: 'default'
--> Action: 'create'

    PLAY [Create] ******************************************************************

    TASK [Create molecule instance(s)] *********************************************
    changed: [localhost] => (item=None)
    changed: [localhost]

    TASK [Populate instance config dict] *******************************************
    ok: [localhost] => (item=None)
    ok: [localhost]

    TASK [Convert instance config dict to a list] **********************************
    ok: [localhost]

    TASK [Dump instance config] ****************************************************
    changed: [localhost]

    PLAY RECAP *********************************************************************
    localhost                  : ok=4    changed=2    unreachable=0    failed=0


--> Scenario: 'default'
--> Action: 'prepare'

    PLAY [Prepare] *****************************************************************

    TASK [Install python for Ansible] **********************************************
    ok: [instance]

    PLAY RECAP *********************************************************************
    instance                   : ok=1    changed=0    unreachable=0    failed=0
```

#### List

```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $ molecule list
--> Validating schema /home/alf/revard_infra/ansible/roles/db/molecule/default/molecule.yml.
Validation completed successfully.
Instance Name    Driver Name    Provisioner Name    Scenario Name    Created    Converged
---------------  -------------  ------------------  ---------------  ---------  -----------
instance         vagrant        ansible             default          true       false
```

Login
```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $ molecule login -h instance
--> Validating schema /home/alf/revard_infra/ansible/roles/db/molecule/default/molecule.yml.
Validation completed successfully.
Warning: Permanently added '[127.0.0.1]:2201' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-138-generic x86_64)
...
Last login: Wed Nov 14 18:04:48 2018 from 10.0.2.2
vagrant@instance:~$
```

#### Applay config

```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $ molecule converge
--> Validating schema /home/alf/revard_infra/ansible/roles/db/molecule/default/molecule.yml.
Validation completed successfully.
--> Test matrix

└── default
    ├── dependency
    ├── create
    ├── prepare
    └── converge

--> Scenario: 'default'
--> Action: 'dependency'
Skipping, missing the requirements file.
--> Scenario: 'default'
--> Action: 'create'
Skipping, instances already created.
--> Scenario: 'default'
--> Action: 'prepare'
Skipping, instances already prepared.
--> Scenario: 'default'
--> Action: 'converge'

    PLAY [Converge] ****************************************************************

    TASK [Gathering Facts] *********************************************************
    ok: [instance]

    TASK [db : Show info about the env this host belongs to] ***********************
    ok: [instance] => {
        "msg": "This host is in local environment!!!"
    }

    TASK [db : Add APT key] ********************************************************
    changed: [instance]

    TASK [db : Add APT repository] *************************************************
    changed: [instance]

    TASK [db : Install mongodb package] ********************************************
    changed: [instance]

    TASK [db : Configure service supervisor] ***************************************
    changed: [instance]

    TASK [db : Change mongo config file] *******************************************
    changed: [instance]

    RUNNING HANDLER [db : restart mongod] ******************************************
    changed: [instance]

    PLAY RECAP *********************************************************************
    instance                   : ok=8    changed=6    unreachable=0    failed=0
```

#### Test
```
alf@alf-pad~/revard_infra/ansible/roles/db (ansible-4) $  molecule verify
--> Validating schema /home/alf/revard_infra/ansible/roles/db/molecule/default/molecule.yml.
Validation completed successfully.
--> Test matrix

└── default
    └── verify

--> Scenario: 'default'
--> Action: 'verify'
--> Executing Testinfra tests found in /home/alf/revard_infra/ansible/roles/db/molecule/default/tests/...
    ============================= test session starts ==============================
    platform linux2 -- Python 2.7.15rc1, pytest-4.0.0, py-1.7.0, pluggy-0.8.0
    rootdir: /home/alf/revard_infra/ansible/roles/db/molecule/default, inifile:
    plugins: testinfra-1.17.0
collected 2 items

    tests/test_default.py ..                                                 [100%]

    =========================== 2 passed in 5.29 seconds ===========================
Verifier completed successfully.
```

### Ansible

You need to use ansible-galaxy to install roles from env dirs (stage, prod) where is requirements.yml  file.

```
$ > ansible-galaxy install -r requirements.yml -p roles/
- downloading role 'nginx', owned by jdauphant
- downloading role from https://github.com/jdauphant/ansible-role-nginx/archive/v2.21.1.tar.gz
- extracting jdauphant.nginx to /home/tgz/revard_infra/ansible/environments/stage/roles/jdauphant.nginx
- jdauphant.nginx (v2.21.1) was installed successfully
- extracting test-ansible-role-db to /home/tgz/revard_infra/ansible/environments/stage/roles/test-ansible-role-db
- test-ansible-role-db was installed successfully
```


## HW-10 Ansible-3
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-3)](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-3)

Read previous sections (HW 8-9) for project installation.  

### Ansible 

Main dirs - roles, enviroments and palybooks. 

#### Ansible-galaxy

Use ansible-galaxy to install nginx role:
```
$ > ansible-galaxy install -r environments/stage/requirements.yml
- downloading role 'nginx', owned by jdauphant
- downloading role from https://github.com/jdauphant/ansible-role-nginx/archive/v2.21.1.tar.gz
- extracting jdauphant.nginx to /home/alf/revard_infra/ansible/roles/jdauphant.nginx
- jdauphant.nginx (v2.21.1) was installed successfully
```
Add to .gitinfnore jdauphant.nginx. Manual can be found here https://github.com/jdauphant/ansible-role-nginx

#### Ansible Vault

Put ansible vault key in ~/.ansible/vault.key.

Documents about vault https://docs.ansible.com/ansible/devel/user_guide/vault.html 

Good examples how to create key can be found here https://gist.github.com/hvanderlaan/ae5d7f62d42c927fdad42309d25c9693. 

Nice one:
```
# create large random password for ansible-vault
openssl rand -base64 2048 > ansible-vault.pass
```

Encrypt files, key writed in ansible.cfg
```
$ ansible-vault encrypt environments/prod/credentials.yml
$ ansible-vault encrypt environments/stage/credentials.yml
```

### Deploy

For deploy application run:

```
$ > ansible-playbook -i environments/prod/gce.py playbooks/site.yml
...
PLAY RECAP *******************************************************************
reddit-app                 : ok=27   changed=18   unreachable=0    failed=0
reddit-db                  : ok=4    changed=2    unreachable=0    failed=0
```

### Trytravis

We can use trytravis for testing purpose.

Manual https://github.com/SethMichaelLarson/trytravis

Install `pip install trytravis`

Setup trytravis `$ trytravis --repo https://github.com/[USERNAME]/[REPOSITORY]`

Triger test:

```
 $ trytravis 
Adding a temporary remote to `https://github.com/revard/revard_infra_trytravis`...
Adding all local changes...
Committing local changes...
Pushing to `trytravis` remote...
Reverting to old state...
Waiting for a Travis build to appear for `4634937bc66c4927076186edb0c4e4abb6efc1f7` after `2018-11-11 23:09:28`...
Travis build id: `453623370`
Travis build URL: `https://travis-ci.org/revard/revard_infra_trytravis/builds/453623370`
#1 * linux s bash 
#1 * linux s bash 
#1 * linux s bash 
...
#1 * linux s bash 
#1 P linux s bash 
```

#### Travis automation: checks and tests

In file .travis.yml writed some instructions and tests for checking of project integrity. We use packer, terraform and ansible validation.


## HW-9 Ansible-2
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-2)

### Installation

Clone repository.
```
clone https://github.com/Otus-DevOps-2018-09/revard_infra/
```
Install ansible (ver.>2.7) by any convenient method.

We using gcp dynamic inventory by gce.py script and gcp.ini [taken from here](https://github.com/ansible/ansible/tree/devel/contrib/inventory).
Setup needed vars in gcp.ini.

For setup gcp credentials use this [manual from ansible](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html). !!!WARNING!!! Add *.json to .gitignore for not commiting gcp credentials json file.

There is terraform dynamic inventory script. It can be useful in geterohenus cloud environment. [Link](https://github.com/adammck/terraform-inventory) for installing and setup.

### Usage

#### Packer

For making images use packer from root project dir:

```
$ > packer build -var-file=packer/variables.json packer/app.json
googlecompute output will be in this color.

==> googlecompute: Checking image does not exist...
==> googlecompute: Creating temporary SSH key for instance...
==> googlecompute: Using image: ubuntu-1604-xenial-v20181030
==> googlecompute: Creating instance...
...
```

#### Terraform

For creating VM and infrastructure cd in dir terraform/stage:

```
$ > terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
i  + create

Terraform will perform the following actions:

  + module.app.google_compute_address.app_ip
      id:                                                  <computed>
      address:                                             <computed>
      address_type:                                        "EXTERNAL"
      name:                                                "reddit-app-ip"
      project:                                             <computed>
      region:                                              <computed>
      self_link:                                           <computed>
...module.app.google_compute_instance.app: Creation complete after 39s (ID: reddit-app)
module.db.google_compute_instance.db: Creation complete after 1m0s (ID: reddit-db)

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

app_external_ip = [
    35.240.xx.xxx
]
db_external_ip = [
    35.240.xx.xxx
]

```

#### Ansible

Don`t forget to change variable host in app.yml, db.yml, deploy.yml. It depends on groups from dynamic inventory output.

For deploying application by ansible use:

```
$ > ansible-playbook  site.yml

PLAY [Configure MongoDB] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************
ok: [reddit-db]

...

TASK [bundle install] **************************************************************************************************************************************************************************
changed: [reddit-app]

RUNNING HANDLER [restart puma] *****************************************************************************************************************************************************************
changed: [reddit-app]

PLAY RECAP *************************************************************************************************************************************************************************************
reddit-app                 : ok=9    changed=7    unreachable=0    failed=0
reddit-db                  : ok=3    changed=2    unreachable=0    failed=0
```

You can use --check for dry run:

```
$ > ansible-playbook  site.yml --check
```


## HW-8 Ansible-1
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=ansible-1)

### Installation and setup

Install python and ansible if needed.
Setup ansible.cfg like in repo.
Create inventory file. Different examples of types you can see in ansible dir.
You can use playbook example clone.yml.

### For using JSON format of inventory you need use command with script:

```
$ > ansible all -i inventory.py -m ping
104.155.100.xx | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
104.155.28.xx | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
You can find script in ansible dir. 


## HW-7 Terraform-2
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=terraform-2)

### Create modules
Make dirs for modules and load modules. Don`t forget about variables.
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
Go to each dir end run
```
$ terraform init
...
$ terraform plan
...
```

### Create backend configuration.

Create backend.tf files in env dirs. Then run:
```
 $ terraform init
Initializing modules...
- module.app
- module.db
- module.vpc

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
...
```
Than we can use all the power of deployment and provisioning! 


## HW-6 Terraform -1 
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=terraform-1)

Create config for deploying reddit servers and load balancer.

Be aware with parameters when using multiple instances. 

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

## HW-5 Packer base
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=packer-base)

### Installation and use
 
Packer configs in directory packer.

All scripts in directory packer/scripts.

User commands bellow to get full installed image and VM fo puma server.

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

## HW-4 Cloud test
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=cloud-testapp)

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


## HW-3 Bastion
![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/revard_infra.svg?branch=cloud-bastion)

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


