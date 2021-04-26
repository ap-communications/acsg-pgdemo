# How to build bff file

```
# define acr name
export ACR_NAME=<put your acr name>

# define bff app version
export TAG=<app versoin>

# build image and push it to azure container registory
./gradlew jib --image=${ACR_NAME}.azurecr.io/bff:${TAG}
```