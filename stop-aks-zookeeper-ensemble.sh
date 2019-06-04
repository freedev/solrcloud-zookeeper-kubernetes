#!/bin/bash

kubectl delete statefulset zk

kubectl delete service zookeeper

kubectl delete pvc volzookeeper-zk-0
kubectl delete pvc volzookeeper-zk-1
kubectl delete pvc volzookeeper-zk-2

kubectl delete storageclasses.storage.k8s.io azurefile-ensemble

kubectl delete configmap zookeeper-ensemble-config 


