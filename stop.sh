#!/bin/bash

kubectl delete statefulset solr
kubectl delete statefulset zk

kubectl delete svc solr-service
kubectl delete svc solrcluster
kubectl delete svc zk-service
kubectl delete svc zkensemble

kubectl delete configmap solr-config 
kubectl delete configmap zookeeper-config 

kubectl delete pvc volsolr-solr-0
kubectl delete pvc volzookeeper-zk-0

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

kubectl delete storageclass store-zkensemble
kubectl delete sc store-solrcluster
