#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 
kubectl create configmap zookeeper-config --from-env-file=configmap/zookeeper-config.properties 

kubectl get configmap

kubectl create -f aks/storageclass-azurefile.yml
kubectl create -f aks/pvc-zookeeper.yml
kubectl create -f aks/pvc-solr.yml

kubectl get pvc

kubectl create -f statefulsets/statefulset-zookeeper.yml

sleep 30

kubectl create -f services/service-zookeeper.yml

kubectl create -f statefulsets/statefulset-solr.yml

sleep 30

kubectl create -f services/service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper deployments"
echo "created solr and zookeeper services"
echo ""

