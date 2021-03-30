SolrCloud Zookeeper Kubernetes
==============================

# Introduction

This project aims to help developers and newbies that would try latest version of SolrCloud (and Zookeeper) in a Kubernetes environment.

Here you'll find basically two different configuration:

* one (or more) Solr instance and one Zookeeper configured as Standalone node
* one (or more) Solr instance and a Zookeeper Ensemble (which means a cluster)

The Zookeeper configuration (and interaction with Solr) is the hardest part of the project.
It is important to point out that Zookeeper has two different configuration: Standalone and Ensemble.

* Standalone has only one node
* Ensemble is a cluster and has always an odd number of nodes starting from 3 (i.e. 3, 5, 7, etc.).  

Here we need two different configuration (StatefulSet) for Zookeeper, depending if you want have Standalone or Ensemble. Of course if you need to deploy an high availablity configuration, there are no ways, you can't have a single point of failure so you need to start an Ensemble.

Solr on the other hand can run one or more instances transparentely from the zookeeper configuration, it just need to have one or more Zookeeper correctly configured and running a version compatible with the Sor version you choose.

# Kubernetes Deployment Envs

Here are described following Kubernetes Deployment Envs:

* Kubernetes with Docker for Desktop (local)
* Azure Kubernetes Services (AKS)
* Amazon Elastic Kubernetes Service (EKS)
* Google Container Engine (GKE) (this part of the project should be updated)
* Minikube (local)

At end of installation Solr (port 8983) and Zookeeper (port 2181) are reachable via kubernetes services that acts as TCP [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer).

Note: Use CloudSolrClient in your Java client application only inside the Kubernetes Cluster, from outside better if you use HttpSolrClient via the loadbalancer.

## Prerequisite for Kubernetes with Docker for Desktop

* [install Docker for Desktop lastest](https://www.docker.com/community-edition) version aka Community edition.

## Prerequisite for Google Cloud installation

* Install Google Cloud SDK - https://cloud.google.com/sdk/downloads
* Follow the Kubernetes Engine Quickstart - https://cloud.google.com/kubernetes-engine/docs/quickstart

## Prerequisite for Azure AKS installation

* Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* Then run: `az aks install-cli`

## Prerequisite for Minikube installation

* [install Docker lastest](https://docs.docker.com/engine/installation/) version or Docker for Desktop
* [install Minikube latest](https://github.com/kubernetes/minikube#minikube) version  
* install a [VM driver](https://github.com/kubernetes/minikube#quickstart) compatible with your environment (MacOS, Linux, Windows).

## Quick start

If you want try a light configuration with 1 SolrCloud container and 1 Zookeeper container, start with:

    git clone https://github.com/freedev/solrcloud-zookeeper-kubernetes.git
    cd solrcloud-zookeeper-kubernetes

## Kubernetes with Docker for Desktop quick start

    ./start.sh

Then run the command `kubectl get pods` and `kubectl get service` to ensure that pods and services were created 
correctly:

    $ kubectl get pods
    NAME     READY   STATUS    RESTARTS   AGE
    solr-0   1/1     Running   0          2m26s
    zk-0     1/1     Running   1          2m31s

    $ kubectl get service
    NAME           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    kubernetes     ClusterIP      10.96.0.1        <none>        443/TCP          4d
    solr-service   LoadBalancer   10.100.213.138   localhost     8983:30955/TCP   1s
    solrcluster    ClusterIP      None             <none>        <none>           1s
    zk-service     LoadBalancer   10.109.138.223   localhost     2181:30063/TCP   1s
    zkensemble     ClusterIP      None             <none>        <none>           1s

So you'll find the SorlCloud cluster at: http://localhost:8983/solr/#/

## Azure AKS quickstart

* You need a Kubernetes Cluster - [Azure Kubernetes Service (AKS) quickstart](https://docs.microsoft.com/en-us/azure/aks/)

Now you can start your cluster:

    start.sh

To find the services load balancer just run:

    $ kubectl get services

## Amazon Elastic Kubernetes Service (Amazon AWS EKS) quickstart

* You need a Kubernetes Cluster - [Creating an Amazon EKS Cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)

```
$ eksctl create cluster --name solr-dev --nodegroup-name standard-workers --node-type t3a.medium --nodes 4  --node-ami auto --nodes-min 1 --nodes-max 4
```

Now you can start your cluster:

    start.sh

To find the services load balancer just run:

    $ kubectl get services
    NAME           TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)          AGE
    kubernetes     ClusterIP      10.100.0.1       <none>                                                                   443/TCP          13m
    solr-service   LoadBalancer   10.100.115.145   a50c0fe32b57211e9a3fc0ae1e2f29a2-134001589.eu-west-1.elb.amazonaws.com   8983:30107/TCP   107s
    solrcluster    ClusterIP      None             <none>                                                                   <none>           107s
    zk-service     LoadBalancer   10.100.134.160   a502a5087b57211e9a3fc0ae1e2f29a2-301817188.eu-west-1.elb.amazonaws.com   2181:32609/TCP   108s
    zkensemble     ClusterIP      None             <none>                                                                   <none>           108s

## Google Cloud quick start

First set default compute/region and compute/zone where create your Kubernetes cluster, for example:

    gcloud config set compute/region europe-west4
     
    gcloud config set compute/zone europe-west4-b

I've choosen `europe-west4` because is near to me, in your case may be better if you a region/zone near you.

Then create the Kubernetes cluster `cluster-solr`, note that in this tutorial I've choosen a machine-type `n1-standard-4` with 4 cores and 15 GB RAM.

    gcloud container clusters create cluster-solr --num-nodes 1 --machine-type n1-standard-4 --disk-size=50 --scopes storage-rw,compute-rw

Now you can start your cluster:

    start.sh

When your cluster is successfully started, you need to understand how to reach the Solr instance.
You can use `kubectl` and `jq`:

    $ kubectl get svc solr-service -o json | jq ".spec.ports[0] | .nodePort"
    8983
    $ kubectl get nodes -o json | jq '.items[0] | .status.addresses[] | select(.type | contains("ExternalIP")) | .address'
    123.123.123.123

If your node is still not reachable, probably it's because of Google cloud default network firewall rules.

    gcloud compute firewall-rules create allow-8983-from-everywhere --allow=TCP:8983 --direction=INGRESS
    gcloud compute firewall-rules create allow-2181-from-everywhere --allow=TCP:2181 --direction=INGRESS
    gcloud compute instances add-tags $(kubectl get node -o json | jq -r '.items[0] | .metadata.name ') --tags=allow-8983-from-everywhere,allow-2181-from-everywhere

## Minikube quick start

Execute this to create and configure a virtual machine that runs a single-node Kubernetes cluster.

    minikube start --extra-config=apiserver.ServiceNodePortRange=1-50000

Note: Minikube normally does not handle [LoadBalancer Services](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer). I've choose LoadBalancer services to expose externally solr and zookeeper.
 only for Minikube you need to use [NodePort Service Type](https://kubernetes.io/docs/concepts/services-networking/#nodeport)

This command also configures your kubectl installation to communicate with this cluster.

After that you can finally start (create) your SolrCloud cluster with 1 Solr instance and 1 Zookeeper instance:

    ./start-minikube.sh

Then run the command `kubectl get pods` to ensure that the pods were created correctly:

    $ kubectl get pods
    NAME     READY   STATUS    RESTARTS   AGE
    solr-0   1/1     Running   0          2m26s
    zk-0     1/1     Running   1          2m31s

Then run the command `minikube service` to see where the services are (which port and ip address):

    minikube service list

    |-------------|----------------------|----------------------------|
    |  NAMESPACE  |         NAME         |            URL             |
    |-------------|----------------------|----------------------------|
    | default     | kubernetes           | No node port               |
    | default     | solr-service         | http://192.168.99.101:8983 |
    | default     | solrcluster          | No node port               |
    | default     | zk-service           | http://192.168.99.101:2181 |
    | default     | zkensemble           | No node port               |
    | kube-system | kube-dns             | No node port               |
    | kube-system | kubernetes-dashboard | No node port               |
    |-------------|----------------------|----------------------------|

As you can imagine, this is an example of the returned output, there is the ip address and the port for `solr-service` and `zk-service`.
So you'll find the SorlCloud cluster at: http://192.168.99.101:8983

Note: The ip address 192.168.99.101 allocated with minikube will change from environment to environment.

## Shutdown

If you want shutdown Solr and Zookeeper just run:

    ./stop.sh 

## Looking at the logs

    kubectl exec -t -i zk-0 -- tail -100f /store/logs/zookeeper.log

### Introduction to Stateful application in Kubernetes

Before to deploy Solr or Zookeeper in Kubernetes, it is important understand what's the difference between Stateless and Stateful applications in Kubernetes.

> Stateless applications
>
> A stateless application does not preserve its state and saves no data to persistent storage — all user and session data stays with the client.
>
> Some examples of stateless applications include web frontends like Nginx, web servers like Apache Tomcat, and other web applications.
>
> You can create a Kubernetes Deployment to deploy a stateless application on your cluster. Pods created by Deployments are not unique and do not preserve their state, which makes scaling and updating stateless applications easier.
>
> Stateful applications
>
>A stateful application requires that its state be saved or persistent. Stateful applications use persistent storage, such as persistent volumes, to save data for use by the server or by other users.
>
>Examples of stateful applications include databases like MongoDB and message queues like Apache ZooKeeper.
>
>You can create a Kubernetes StatefulSet to deploy a stateful application. Pods created by StatefulSets have unique identifiers and can be updated in an ordered, safe way.

So a Solrcloud Cluster matches exactly the kind of Stateful application previously described.
And we have to create the environment following these steps:

1. create configmap where store the cluster configuration
2. create statefulsets for Solr and Zookeeper that can write their data on persistent volumes
3. map solr and zookeeper as network services (loadbalancer or nodeport)
