
gcloud container clusters create cluster1 --zone europe-west4-b --num-nodes 1 --machine-type n1-standard-4 --disk-size=50 --scopes storage-rw,compute-rw

gcloud compute disks create --zone europe-west4-b --size 50 --type pd-standard  pd-disk-1
