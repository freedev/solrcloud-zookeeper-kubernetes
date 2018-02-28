# solrcloud-zookeeper-kubernetes
# solrcloud-zookeeper-kubernetes

    kubectl create configmap solr-config --from-literal="solrHome=/store/data" --from-literal="solrPort=30001" --from-literal="zkHost=zookeeper-service:32181" --from-literal="solrHost=solr-service" --from-literal="solrLogsDir=/store/logs"
    kubectl create configmap zookeeper-config --from-literal="zooMyId=1" --from-literal="zooLogDir=/store/logs" --from-literal="zooDataLogDir=/store/datalog" --from-literal="zooPort=32181" --from-literal="zooDataDir=/store/data"
