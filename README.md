# revard_infra

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

