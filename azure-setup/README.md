# Setup azure resurces

```
# deploy resource group
az deployment sub create -f deploy-resource-group.bicep --location japaneast

# deploy workspace acr and aks
az deployment group create -f deploy-aks.bicep --resource-group $RESOURCE_GROUP
```