#!/bin/sh
#create network cni flannel
kubectl apply -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/kube-flannel.yml

#create admin dashboard
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/admin-dashboard.yaml

#create dashboard kubernetes
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/dashboard.yaml

#create influxdb
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/influxdb.yaml

#create heapster and rbac mode
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/heapster.yaml
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/heapster-rbac.yaml

#create grafana dashboard
kubectl create -f https://raw.githubusercontent.com/gotwasin/install-k8s/v1.11.4/template/grafana.yaml

# This command will print the port exposed by the Grafana service. We need to connect to the floating IP:PORT later
echo "port for access grafana"
kubectl get svc -n kube-system | grep grafana
 
# This command will print the port exposed by the Kubernetes dashboard service. We need to connect to the floating IP:PORT later
echo "port for access dashboard"
kubectl -n kube-system get service kubernetes-dashboard

# This command will print a token that can be used to authenticate in the Kubernetes dashboard
echo "token for dashboard"
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep "token:"
