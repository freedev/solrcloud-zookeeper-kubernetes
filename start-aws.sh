#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 
kubectl create configmap zookeeper-config --from-env-file=configmap/zookeeper-config.properties 

kubectl get configmap

kubectl create -f aws/storageclass-solrcluster.yml
kubectl create -f aws/storageclass-zkensemble.yml

kubectl create -f statefulsets/statefulset-zookeeper.yml

kubectl get pvc

kubectl create -f services/service-zookeeper-ensemble.yml

kubectl create -f statefulsets/statefulset-solr.yml

kubectl create -f services/service-solr-cluster.yml

kubectl get pod
kubectl get deployment
kubectl get service

