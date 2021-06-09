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
    export AZ_POSTGRESQL_USERNAME=`echo -n ${PG_ADMIN_USER}@${PG_HOST} | base64` && \
    export AZ_POSTGRESQL_PASSWORD=`echo -n ${PG_ADMIN_PASSWORD} | base64` && \
    export AZ_POSTGRESQL_HOST=`echo -n ${PG_HOST} | base64` && \
    export AZ_POSTGRESQL_DATABASE=`echo -n ${PG_DATABASE} | base64` && \
    export AZ_REDIS_HOST=`echo -n ${REDIS_HOST} | base64` && \
    export AZ_REDIS_PASSWORD=`echo -n ${REDIS_PASSWORD} | base64` && \
    yq e '.data.postgresUser = env(AZ_POSTGRESQL_USERNAME)' template-secret.yaml  \
    | yq e '.data.postgresPassword = env(AZ_POSTGRESQL_PASSWORD)' - \
    | yq e '.data.postgresHost = env(AZ_POSTGRESQL_HOST)' - \
    | yq e '.data.postgresDatabase = env(AZ_POSTGRESQL_DATABASE)' - \
    | yq e '.data.redisHost = env(AZ_REDIS_HOST)' - \
    | yq e '.data.redisPassword = env(AZ_REDIS_PASSWORD)' - \
    | yq e '.data.instrumentationKey = env(AI_KEY)' - > secret.yaml

## deploy secret
kubectl apply -f secret.yaml

## deploy ingress
kubectl apply -f external-service.yaml -n ingress-basic
kubectl apply -f ingress.yaml -n ingress-basic

```
