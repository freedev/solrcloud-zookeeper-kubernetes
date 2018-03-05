#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 
kubectl create configmap zookeeper-config --from-env-file=configmap/zookeeper-config.properties 

kubectl get configmap

kubectl create -f google-cloud/pv-zookeeper.yml
kubectl create -f google-cloud/pv-solr.yml

kubectl create -f google-cloud/pvc-zookeeper.yml
kubectl create -f google-cloud/pvc-solr.yml

kubectl get pv
kubectl get pvc

kubectl create -f statefulsets/statefulset-zookeeper.yml
kubectl create -f services/service-zookeeper.yml

kubectl create -f statefulsets/statefulset-solr.yml
kubectl create -f services/service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper deployments"
echo "created solr and zookeeper services"
echo ""

