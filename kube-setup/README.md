https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm

kubectl create -f mrs-setup-kube2-dev.yml
kubectl create -f mrs-setup-kube2-prod.yml


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

kubectl apply -f mrs-setup-ingress.yaml

kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --set installCRDs=true

kubectl apply -f production_issuer.yaml

Add TLS

annotations:
[...]
 cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - www.mikeroysoft.com
    - dev.mikeroysoft.com
    secretName: mrs-kubernetes2-tls

kubectl apply -f mrs-setup-kube2-ingress.yml
kubectl describe certificate mrs-kubernetes2-tls


