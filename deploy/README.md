# How to deploy servers

see [server](server) folder and [bff](bff) folder

## deploy ingress

```
# deploy ingress
kubectl apply -f ingress.yaml

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

# deploy secret
kubectl apply -f secret.yaml

```
