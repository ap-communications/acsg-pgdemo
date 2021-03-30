# Setup azure resurces

```
# deploy resource group
az deployment sub create -f deploy-resource-group.bicep --location japaneast

# deploy application insights
az deployment group create -f deploy-app-insights.bicep --resource-group $RESOURCE_GROUP


# deploy workspace acr and aks
az deployment group create -f deploy-aks.bicep --resource-group $RESOURCE_GROUP
```