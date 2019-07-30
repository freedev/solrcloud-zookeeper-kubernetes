#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 
kubectl create configmap zookeeper-config --from-env-file=configmap/zookeeper-config.properties 

kubectl get configmap

kubectl apply -f minikube/storageclass-solrcluster.yml
kubectl apply -f minikube/storageclass-zkensemble.yml

kubectl apply -f statefulsets/statefulset-zookeeper.yml

sleep 5

kubectl apply -f minikube/service-zookeeper.yml

kubectl apply -f statefulsets/statefulset-solr.yml

sleep 5

kubectl apply -f minikube/service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper statefulsets"
echo "created solr and zookeeper services"
echo ""

