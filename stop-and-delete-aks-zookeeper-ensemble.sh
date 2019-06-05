#!/bin/bash

kubectl delete statefulset zk

kubectl delete service zkensemble
kubectl delete service zk-service

kubectl delete pvc volzookeeper-zk-0
kubectl delete pvc volzookeeper-zk-1
kubectl delete pvc volzookeeper-zk-2

kubectl delete configmap zookeeper-ensemble-config 


