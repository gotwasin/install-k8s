#!/bin/sh
apt-get install -y jq
postDataJson="{\"projectname\":\"got\"}"
datamaster=$(curl  --header "Content-Type: application/json" --request POST --data ${postDataJson} http://203.150.107.66/get_data )
ipmaster=$(echo $datamaster | jq -r '.[0].ipmaster')
token=$(echo $datamaster | jq -r '.[0].token')
discoverytoken=$(echo $datamaster | jq -r '.[0].discoverytoken')
kubeadm join $ipmaster:6443 --token $token --discovery-token-ca-cert-hash sha256:$discoverytoken
