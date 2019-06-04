#!/bin/bash

kubectl create configmap zookeeper-ensemble-config --from-env-file=configmap/zookeeper-ensemble-config.properties 

kubectl get configmap

kubectl create -f aks/storageclass-azurefile-ensemble.yml

kubectl get storageclass

kubectl create -f services/service-zookeeper-ensemble.yml

kubectl get service

kubectl create -f statefulsets/statefulset-zookeeper-ensemble.yml

kubectl get statefulsets
