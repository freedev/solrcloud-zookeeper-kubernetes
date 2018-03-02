#!/bin/bash

# minikube start --logtostderr --vm-driver=hyperkit

kubectl create configmap solr-config --from-literal="solrHome=/store/data" --from-literal="solrPort=8983" --from-literal="zkHost=zookeeper-service:2181" --from-literal="solrHost=solr-service" --from-literal="solrLogsDir=/store/logs"

kubectl create configmap zookeeper-config --from-literal="zooMyId=1" --from-literal="zooLogDir=/store/logs" --from-literal="zooDataLogDir=/store/datalog" --from-literal="zooPort=2181" --from-literal="zooDataDir=/store/data"

kubectl get configmap

kubectl create -f google-cloud/pv-zookeeper.yml
kubectl create -f google-cloud/pv-solr.yml

kubectl create -f google-cloud/pvc-zookeeper.yml
kubectl create -f google-cloud/pvc-solr.yml

kubectl get pv
kubectl get pvc

kubectl create -f statefulsets/statefulset-zookeeper.yml
kubectl create -f services/service-zookeeper.yml

kubectl create -f statefulsets/statefulset--solr.yml
kubectl create -f services/service-solr.yml

kubectl get pod
kubectl get deployment
kubectl get service

echo "created solr and zookeeper deployments"
echo "created solr and zookeeper services"
echo ""

minikube service solr-service --url
