# How to deploy api server 


## make ConfigMap yaml files and deploy

```
# deploy application
kubectl apply -f config.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml

```