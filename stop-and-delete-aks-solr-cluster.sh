#!/bin/bash

kubectl delete statefulset solr

kubectl delete service solrcluster
kubectl delete service solr-service

kubectl delete pvc volsolr-solr-0
kubectl delete pvc volsolr-solr-1
# kubectl delete pvc volsolr-solr-2

PV=$(kubectl get pv | grep "default/volsolr-solr-" | awk '{ print $1}')
if [ "$PV" == "" ]
then
   echo "persistent volume not found"
else
   kubectl delete pv $PV
fi

kubectl delete configmap solr-cluster-config 
kubectl delete sc store-solrcluster

