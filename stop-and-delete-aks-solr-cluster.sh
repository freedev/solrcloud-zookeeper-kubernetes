#!/bin/bash

kubectl delete statefulset solr

kubectl delete service solrcluster
kubectl delete service solr-service

kubectl delete pvc volsolr-solr-0
kubectl delete pvc volsolr-solr-1

kubectl delete configmap solr-cluster-config 


