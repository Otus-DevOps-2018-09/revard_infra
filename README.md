# revard_infra

bastion_IP = 35.189.211.216

someinternalhost_IP = 10.132.0.3

testapp_IP = 146.148.127.126

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
