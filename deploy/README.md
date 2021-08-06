# How to deploy servers

see [server](server) folder and [bff](bff) folder

## deploy ingress

```
# ingress controller
## make ingress.yaml
yq eval '(.spec.tls.[] | select(.secretName == "ingress-tls-csi")) |= .hosts[0] = env(DEMO_DOMAIN_NAME)' template-ingress.yaml > ingress.yaml


# secret
## make secret.yaml file for Secret

export AI_KEY=`echo -n $AI_CONNECTION_STRING | base64` && \
    yq e '.data.instrumentationKey = env(AI_KEY)' template-secret.yaml > secret.yaml

## deploy secret
kubectl apply -f secret.yaml

## deploy ingress
kubectl apply -f external-service.yaml -n ingress-basic
kubectl apply -f ingress.yaml -n ingress-basic

```
