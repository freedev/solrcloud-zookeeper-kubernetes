#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 
kubectl create configmap zookeeper-config --from-env-file=configmap/zookeeper-config.properties 

kubectl get configmap

kubectl create -f docker-for-desktop/storageclass-solrcluster.yml
kubectl create -f docker-for-desktop/storageclass-zkensemble.yml

kubectl get pv
kubectl get pvc

kubectl create -f statefulsets/statefulset-zookeeper.yml

sleep 5

kubectl create -f docker-for-desktop/service-zookeeper.yml

kubectl create -f statefulsets/statefulset-solr.yml

sleep 5

kubectl create -f docker-for-desktop/service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper deployments"
echo "created solr and zookeeper services"
echo ""

