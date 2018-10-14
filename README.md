# revard_infra
bastion_IP = 35.189.211.216 
someinternalhost_IP = 10.132.0.3

# One command connect to someinternalhost

tgz@alf-server:~$ ssh  -i ~/.ssh/appuser -A -t appuser@35.189.211.216 "ssh  10.132.0.3"

Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-1021-gcp x86_64)

...

Last login: Sun Oct 14 13:51:22 2018 from 10.132.0.2

appuser@someinternalhost:~$ logout


# Setup ssh alias

See config file in root dir. 

Have problem with tty while connect. Need some bugfix.
