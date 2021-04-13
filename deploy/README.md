# How to make ConfigMap yaml files

## Prerequisite

- install [yq(ver4)](https://github.com/mikefarah/yq/) on your PC
- set InstrumentationKey to environment named AI_CONNECTION_STRING

exx.
export AI_CONNECTION_STRING="InstrumentationKey..."

```
# make secret.yaml file for Secret

export AI_KEY=`echo -n $AI_CONNECTION_STRING | base64` && \
    export AZ_POSTGRESQL_USERNAME=`echo -n ${PG_ADMIN_USER}@${PG_HOST} | base64` && \
    export AZ_POSTGRESQL_PASSWORD=`echo -n ${PG_ADMIN_PASSWORD} | base64` && \
    export AZ_POSTGRESQL_HOST=`echo -n ${PG_HOST} | base64` && \
    export AZ_POSTGRESQL_DATABASE=`echo -n ${PG_DATABASE} | base64` && \
    yq e '.data.postgresUser = env(AZ_POSTGRESQL_USERNAME)' template-secret.yaml  \
    | yq e '.data.postgresPassword = env(AZ_POSTGRESQL_PASSWORD)' - \
    | yq e '.data.postgresHost = env(AZ_POSTGRESQL_HOST)' - \
    | yq e '.data.postgresDatabase = env(AZ_POSTGRESQL_DATABASE)' - \
    | yq e '.data.instrumentationKey = env(AI_KEY)' -  > secret.yaml

# deploy application
kubectl apply -f config.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# deploy ingress
kubectl apply -f ingress.yaml

```