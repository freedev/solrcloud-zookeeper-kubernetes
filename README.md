SolrCloud Zookeeper Kubernetes
==============================

This project aims to help developers and newbies that would try latest version of SolrCloud (and Zookeeper) in a Kubernetes environment.

### Introduction to Stateful application in Kubernetes

Before to deploy Solr or Zookeeper in Kubernetes, it is important understand what's the difference between Stateless 
and Stateful applications in Kubernetes.

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
2. create persistent volumes where Solr indexes and Zookeeper logs can be written
3. map solr and zookeeper as network services 


### Prerequisite for Minikube installation

 * Docker lastest version - https://docs.docker.com/engine/installation/
 * Minikube latest version - https://kubernetes.io/docs/getting-started-guides/minikube/

### Prerequisite for Google Cloud installation

<!---
## Quick start

If you want try a lightweight configuration with 1 SolrCloud container and 1 Zookeeper container, just run:

    git clone https://github.com/freedev/solrcloud-zookeeper-kubernetes.git
    cd solrcloud-zookeeper-kubernetes
    ./start.sh
-->

