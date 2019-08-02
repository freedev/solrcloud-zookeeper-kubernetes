#!/bin/bash

kubectl create configmap zookeeper-ensemble-config --from-env-file=configmap/zookeeper-ensemble-config.properties 

kubectl get configmap

kubectl apply -f aks/storageclass-zkensemble.yml

kubectl get storageclass

kubectl apply -f aks/service-zookeeper-ensemble.yml

kubectl get service

kubectl apply -f statefulsets/statefulset-zookeeper-ensemble.yml

kubectl get statefulsets
