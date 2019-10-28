#!/bin/bash

kubectl delete statefulset solr
kubectl delete statefulset zk

kubectl delete svc solr-service
kubectl delete svc solrcluster
kubectl delete svc zk-service
kubectl delete svc zkensemble

kubectl delete configmap solr-config 
kubectl delete configmap solr-cluster-config
kubectl delete configmap zookeeper-config 
kubectl delete configmap zookeeper-ensemble-config


PVC=$(kubectl get pvc | grep -E "volzookeeper-zk-\d+|volsolr-solr-\d+" | awk '{ print $1}')
if [ "$PVC" == "" ]
then
   echo "persistent volume claim not found"
else
   kubectl delete pvc $PVC
fi

PV=$(kubectl get pv | grep "default/volsolr-solr-" | awk '{ print $1}')
if [ "$PV" == "" ]
then
   echo "persistent volume not found"
else
   kubectl delete pv $PV
fi

PV=$(kubectl get pv | grep "default/volzookeeper-zk-" | awk '{ print $1}')
if [ "$PV" == "" ]
then
   echo "persistent volume not found"
else
   kubectl delete pv $PV
fi

kubectl delete storageclass store-solrcluster
kubectl delete storageclass store-zkensemble

