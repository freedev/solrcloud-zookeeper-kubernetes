gcloud config set compute/region europe-west4
 
gcloud config set compute/zone europe-west4-b
 
gcloud container clusters create cluster1 --num-nodes 1 --machine-type n1-standard-4 --disk-size=50 --scopes storage-rw,compute-rw

gcloud compute disks create --size 50 --type pd-standard  pd-disk-zookeeper

gcloud compute disks create --size 50 --type pd-standard  pd-disk-solr

