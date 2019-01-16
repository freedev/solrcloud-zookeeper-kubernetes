#!/bin/bash

kubectl apply -f https://k8s.io/examples/application/zookeeper/zookeeper.yaml

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 

kubectl get configmap

kubectl create -f services/service-solr.yml
kubectl create -f statefulsets/statefulset-solr.yml

# kubectl create -f rbac-config.yaml
# helm init --service-account tiller
helm install stable/nginx-ingress --namespace kube-system --set controller.replicaCount=2 --set rbac.create=false
kubectl apply -f ingress/ingress.yml

kubectl get pod
kubectl get deployment
kubectl get service
kubectl get service -l app=nginx-ingress --namespace kube-system    # ingress IP
