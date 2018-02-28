#!/bin/bash

minikube start --logtostderr --vm-driver=hyperkit
minikube ssh "sudo chmod 777 /data "

minikube ssh "sudo ip link set docker0 promisc on"

scp -r -i $(minikube ssh-key) data/* docker@$(minikube ip):/data/

minikube ssh "sudo chmod -R 777 /data "

echo "created minikube data directory for Solr and Zookeeper"

kubectl create configmap solr-config --from-literal="solrHome=/store/data" --from-literal="solrPort=30001" --from-literal="zkHost=zookeeper-service:32181" --from-literal="solrHost=solr-service" --from-literal="solrLogsDir=/store/logs"

kubectl create configmap zookeeper-config --from-literal="zooMyId=1" --from-literal="zooLogDir=/store/logs" --from-literal="zooDataLogDir=/store/datalog" --from-literal="zooPort=32181" --from-literal="zooDataDir=/store/data"

kubectl get configmap

kubectl create -f pv-zookeeper.yml
kubectl create -f pv-solr.yml

kubectl create -f pvc-zookeeper.yml
kubectl create -f pvc-solr.yml

kubectl get pv
kubectl get pvc

kubectl create -f deployment-zookeeper.yml
kubectl create -f service-zookeeper.yml

kubectl create -f deployment-solr.yml
kubectl create -f service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper deployments"
echo "created solr and zookeeper services"
echo ""

minikube service solr-service --url
