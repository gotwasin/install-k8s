token=$(kubeadm token list | awk '{print $1}' | sed -n 2p)
discoveryToken=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
ipmaster=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
postDataJson="{\"projectname\":\"wasin\",\"ipmaster\":\"$ipmaster\",\"token\":\"$token\",\"discoverytoken\":\"$discoveryToken\"}"
curl --header "Content-Type: application/json" --request POST --data ${postDataJson} http://203.150.107.66/insert
