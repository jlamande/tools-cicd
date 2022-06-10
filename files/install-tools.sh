#!/bin/bash

## Ansible
sudo apt update
sudo apt install software-properties-common --yes
sudo apt-add-repository --update ppa:ansible/ansible --yes
sudo apt install ansible --yes  && \
ansible --version

## Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" --yes
sudo apt-get update && sudo apt-get install packer --yes  && \
packer --version

## Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" --yes
sudo apt-get update && sudo apt-get install terraform --yes  && \
terraform --version

## Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install default-jre jenkins --yes && \
sudo systemctl status jenkins
# Persisitent IP + Iptables 80 -> 8080
# https://wiki.jenkins.io/display/JENKINS/Running+Jenkins+on+Port+80+or+443+using+iptables
# sudo apt-get install iptables-persistent --yes
# sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

# Other tools
sudo apt-get install awscli jq --yes \
&& aws --version \
&& jq --version

# Here add commands to install other tools of your choice as nodejs, docker, golang, ...
sudo apt install nodejs npm --yes && node -v
