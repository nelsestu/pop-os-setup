#!/bin/bash

# enable trace mode - print all commands to std out
set -o xtrace

# Step 1
echo identifying installed package 
dpkg -l | grep -i docker

# Step 2 - uninstall from apt
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
sudo apt-get purge -y docker-ce-cli
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  

# Step 3 - To remove images, containers, volumes, or user created configuration files on your host, run the following commands:
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
sudo rm /usr/local/bin/docker-compose
sudo rm -rf /etc/docker
sudo rm -rf ~/.docker

# disable trace mode
# set +o xtrace