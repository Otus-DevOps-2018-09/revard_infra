#!/bin/bash
set -e

#echo "----- Installing ruby! -----"
apt update
apt install -y ruby-full ruby-bundler build-essential
