# How to make ConfigMap yaml files

## Prerequisite

- install [yq(ver4)](https://github.com/mikefarah/yq/) on your PC
- set InstrumentationKey to environment named AI_CONNECTION_STRING

exx.
export AI_CONNECTION_STRING="InstrumentationKey..."

```
# make secret.yaml file for Secret

export STR=`echo -n $AI_CONNECTION_STRING | base64` && \
    yq e '.data.instrumentationKey = env(STR)' template-secret.yaml > secret.yaml

# deploy application
kubectl apply -f config.yaml
kubectl apply -f deployment.yaml

# deploy ingress
kubectl apply -f ingress.yaml

```