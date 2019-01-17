#!/bin/bash

# build zookeeper ensenble from k8s repo
kubectl apply -f https://k8s.io/examples/application/zookeeper/zookeeper.yaml

kubectl create configmap solr-config --from-env-file=configmap/solr-config.properties 

kubectl get configmap

# I think the headless service needs creating before the stateful set
kubectl create -f services/service-solr.yml
kubectl create -f statefulsets/statefulset-solr.yml

# init helm
# 1. create service account called tiller
# kubectl create -f service-account/rbac-config.yaml
# 2. init
# helm init --service-account tiller

# create ingress controller (helm)
helm install stable/nginx-ingress --namespace kube-system --set controller.replicaCount=2 --set rbac.create=false

# get eternal ip of ingress controller
kubectl get service -l app=nginx-ingress --namespace kube-system

# create dns for ingress (solr-aks-ingress - created later)

##!/bin/bash
## Public IP address of your ingress controller
#IP="40.115.96.127"
## Name to associate with public IP address
#DNSNAME="solr-aks-ingress"
## Get the resource-id of the public ip
#PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)
## Update public ip address with DNS name
#az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# create cert-manager 
# This is a 2-step process as a work-around for some issues with CRDs
kubectl apply \
    -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
helm repo update
helm install stable/cert-manager \
    --namespace kube-system  \
    --set ingressShim.defaultIssuerName=letsencrypt-prod  \
    --set ingressShim.defaultIssuerKind=ClusterIssuer \
    --set rbac.create=false \
    --set serviceAccount.create=false \
    --set createCustomResource=false

# create cert issuer (not sure on dependency on above)
kubectl apply -f ingress/cluster-issuer.yaml

# create cert 
kubectl apply -f ingress/certificates.yaml

# create ingress
kubectl apply -f ingress/ingress.yml

kubectl get pod
kubectl get deployment
kubectl get service
kubectl get service -l app=nginx-ingress --namespace kube-system    # ingress IP
