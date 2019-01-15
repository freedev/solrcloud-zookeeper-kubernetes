#!/bin/bash

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 

kubectl get configmap

kubectl create -f services/service-solr.yml
kubectl create -f statefulsets/statefulset-solr.yml
kubectl apply -f ingress/ingress.yml

kubectl get pod
kubectl get deployment
kubectl get service

