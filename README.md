SolrCloud Zookeeper Kubernetes
==============================

This project aims to help developers and newbies that would try latest version of SolrCloud (and Zookeeper) in a 
Kubernetes environment.

Now are currently described following Kubernetes Deployment Models:

* Minikube
* Kubernetes with Docker for Desktop (edge version)
* Google Container Engine (GKE)

### Prerequisite for Minikube installation

 * [install Docker lastest](https://docs.docker.com/engine/installation/) version or Docker for Desktop - 
 * [install Minikube latest](https://github.com/kubernetes/minikube#minikube) version - also note that this also means 
 install a [VM driver](https://github.com/kubernetes/minikube#quickstart) compatible with your environment 
 (MacOS, Linux, Windows).

### Prerequisite for Kubernetes with Docker for Desktop

 * [install Docker for Desktop lastest](https://www.docker.com/community-edition) version aka Community edition. 
 *Pay attention that at time of writing only **Edge channel** has Kubernetes embedded*.

### Prerequisite for Google Cloud installation

 * Install Google Cloud SDK - https://cloud.google.com/sdk/downloads
 * Follow the Kubernetes Engine Quickstart - https://cloud.google.com/kubernetes-engine/docs/quickstart

### Quick start

If you want try a light configuration with 1 SolrCloud container and 1 Zookeeper container, start with:

    git clone https://github.com/freedev/solrcloud-zookeeper-kubernetes.git
    cd solrcloud-zookeeper-kubernetes

### Minikube quick start

Execute `minikube start` to create and configure a virtual machine that runs a single-node Kubernetes cluster. 

    minikube start

This command also configures your kubectl installation to communicate with this cluster.

Once minikube is started you need to prepare the environment to deploy Solr and Zookeeper. Because both Solr and Zookeeper need a place (PersistentVolume) where store their data. 
Running `prepare-minikube.sh`:

    ./prepare-minikube.sh

This will create inside the minikube virtual machine the directories:

    /data/zookeeper/datalog
    /data/zookeeper/data
    /data/zookeeper/logs
    /data/solr/data
    /data/solr/logs

Zookeeper and Solr will permanently read and write their data there.
After that you can finally start (create) your SolrCloud cluster with 1 Solr instance and 1 Zookeeper instance:

    ./start-minikube.sh

Then run the command `kubectl get pods` to ensure that the pods were created correctly: 

    $ kubectl get pods
    NAME             READY     STATUS    RESTARTS   AGE
    solr-ss-0        1/1       Running   0          12m
    zookeeper-ss-0   1/1       Running   0          12m

Then run the command `minikube service` to see where the services are (which port and ip address): 

    minikube service list

    |-------------|----------------------|---------------------------|
    |  NAMESPACE  |         NAME         |            URL            |
    |-------------|----------------------|---------------------------|
    | default     | kubernetes           | No node port              |
    | default     | solr-service         | http://192.168.64.5:32080 |
    | default     | zookeeper-service    | http://192.168.64.5:32181 |
    | kube-system | kube-dns             | No node port              |
    | kube-system | kubernetes-dashboard | http://192.168.64.5:30000 |
    |-------------|----------------------|---------------------------|

As you can imagine, this is an example of the returned output, there is the ip address and the port for `solr-service` and `zookeeper-service`.
So you'll find the SorlCloud cluster at: http://192.168.64.5:32080

On the other hand you could use `kubectl` and `jq`:

    $ kubectl get svc solr-service -o json | jq ".spec.ports[0] | .nodePort"
    32080
    $ kubectl get nodes -o json | jq '.items[0] | .status.addresses[] | select(.type | contains("ExternalIP")) | .address'
    192.168.64.5

### Kubernetes with Docker for Desktop quick start

    ./start-docker-for-desktop.sh

Then run the command `kubectl get pods` and `kubectl get service` to ensure that pods and services were created 
correctly: 

    $ kubectl get pods
    NAME             READY     STATUS    RESTARTS   AGE
    solr-ss-0        1/1       Running   0          12m
    zookeeper-ss-0   1/1       Running   0          12m

    $ kubectl get service
    NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
    kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP           12d
    solr-service        NodePort    10.98.55.176    <none>        32080:32080/TCP   32m
    zookeeper-service   NodePort    10.104.43.251   <none>        32181:32181/TCP   32m

So you'll find the SorlCloud cluster at: http://localhost:32080/solr/#/

### Google Cloud quick start

First set default compute/region and compute/zone where create your Kubernetes cluster, for example:

    gcloud config set compute/region europe-west4
     
    gcloud config set compute/zone europe-west4-b

I've choosen `europe-west4` because is near to me, in your case may be better if you a region/zone near you.

Then create the Kubernetes cluster `cluster-solr`, note that in this tutorial I've choosen a machine-type `n1-standard-4` with 4 cores and 15 GB RAM.

    gcloud container clusters create cluster-solr --num-nodes 1 --machine-type n1-standard-4 --disk-size=50 --scopes storage-rw,compute-rw
    
Once your Google Cloud Kubernetes cluster is started you need to prepare the environment to deploy Solr and Zookeeper. Because both Solr and Zookeeper need a place (PersistentVolume) where store their data, so we create two 50GB disks:
    
    gcloud compute disks create --size 50 --type pd-standard  pd-disk-zookeeper
    
    gcloud compute disks create --size 50 --type pd-standard  pd-disk-solr

Now you can start your cluster:

    start-google-cloud.sh

When your cluster is successfully started, you need to understand how to reach the Solr instance. 
You can use `kubectl` and `jq`:

    $ kubectl get svc solr-service -o json | jq ".spec.ports[0] | .nodePort"
    32080
    $ kubectl get nodes -o json | jq '.items[0] | .status.addresses[] | select(.type | contains("ExternalIP")) | .address'
    123.123.123.123

If your node is still not reachable, probably it's because of Google cloud default network firewall rules.

    gcloud compute firewall-rules create allow-32080-from-everywhere --allow=TCP:32080 --direction=INGRESS
    gcloud compute firewall-rules create allow-32181-from-everywhere --allow=TCP:32181 --direction=INGRESS
    gcloud compute instances add-tags $(kubectl get node -o json | jq -r '.items[0] | .metadata.name ') --tags=allow-32080-from-everywhere,allow-32181-from-everywhere

### Shutdown

If you want shutdown Solr and Zookeeper just run:

    ./stop.sh

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
