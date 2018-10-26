#!/bin/sh
# Deploy the monitoring stack based on Heapster, Influxdb and Grafana
git clone https://github.com/kubernetes/heapster.git
cd heapster
 
# Change the default Grafana config to use NodePort so we can reach the Grafana UI over the Public/Floating IP
sed -i 's/# type: NodePort/type: NodePort/' deploy/kube-config/influxdb/grafana.yaml
 
kubectl create -f deploy/kube-config/influxdb/
kubectl create -f deploy/kube-config/rbac/heapster-rbac.yaml
 
 
# The commands below will deploy the Kubernetes dashboard
 
wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
echo '  type: NodePort' >> kubernetes-dashboard.yaml
kubectl create -f kubernetes-dashboard.yaml
 
# Create an admin user that will be needed in order to access the Kubernetes Dashboard
sudo bash -c 'cat << EOF > admin-user.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF'
 
kubectl create -f admin-user.yaml
 
# Create an admin role that will be needed in order to access the Kubernetes Dashboard
sudo bash -c 'cat << EOF > role-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF'
 
kubectl create -f role-binding.yaml
 
 
# This command will create a token and print the command needed to join slave workers
kubeadm token create --print-join-command --ttl 0
 
# This command will print the port exposed by the Grafana service. We need to connect to the floating IP:PORT later
kubectl get svc -n kube-system | grep grafana
 
# This command will print the port exposed by the Kubernetes dashboard service. We need to connect to the floating IP:PORT later
kubectl -n kube-system get service kubernetes-dashboard
 
 
# This command will print a token that can be used to authenticate in the Kubernetes dashboard
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep "token:"
