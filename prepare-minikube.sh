#!/bin/bash

minikube ssh "sudo mkdir -p /data "

minikube ssh "sudo chmod 777 /data "

minikube ssh "sudo ip link set docker0 promisc on"

scp -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r -i $(minikube ssh-key) data/* docker@$(minikube ip):/data/

minikube ssh "sudo chmod -R 777 /data "

echo "Created minikube data directory for Solr and Zookeeper"
