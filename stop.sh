#!/bin/bash


kubectl delete statefulset solr-ss
kubectl delete statefulset zookeeper-ss
kubectl delete svc solr-service
kubectl delete svc zookeeper-service

kubectl delete configmap solr-config 
kubectl delete configmap zookeeper-config 

kubectl delete pvc task-solr-pv-claim
kubectl delete pvc task-zookeeper-pv-claim

kubectl delete pv solr-volume
kubectl delete pv zookeeper-volume
