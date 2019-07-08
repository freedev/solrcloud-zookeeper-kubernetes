#!/bin/bash

kubectl delete statefulset zk

kubectl delete service zkensemble
kubectl delete service zk-service

kubectl delete pvc volzookeeper-zk-0
kubectl delete pvc volzookeeper-zk-1
kubectl delete pvc volzookeeper-zk-2

PV=$(kubectl get pv | grep "default/volzookeeper-zk-" | awk '{ print $1}')
if [ "$PV" == "" ]
then
   echo "persistent volume not found"
else
   kubectl delete pv $PV
fi

kubectl delete configmap zookeeper-ensemble-config 

kubectl delete storageclass store-zkensemble
