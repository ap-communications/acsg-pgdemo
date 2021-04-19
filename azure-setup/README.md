# Setup azure resurces

```bash
# deploy resource group
az deployment sub create -f deploy-resource-group.bicep --location japaneast

# deploy application insights
az deployment group create -f deploy-app-insights.bicep --resource-group $RESOURCE_GROUP

# deploy virtual network
az deployment group create -f deploy-vnet.bicep --resource-group $RESOURCE_GROUP

# deploy workspace acr and aks
az deployment group create -f deploy-aks.bicep --resource-group $RESOURCE_GROUP

# deploy postgresql
az deployment group create -f deploy-pgsql.bicep \
  --resource-group $RESOURCE_GROUP \
  --parameters adminUser=${PG_ADMIN_USER} \
      adminPassword=${PG_ADMIN_PASSWORD}

# deploy redis
az deployment group create -f deploy-redis.bicep -g $RESOURCE_GROUP
```

## Setup virtual machine

```bash
# generate ssh-key (ed25519 is not supported!)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_id_rsa

# store public key to azure
az deployment group create -f deploy-key.bicep -g $RESOURCE_GROUP -p publicKey="$(cat ~/.ssh/azure_id_rsa.pub)"

# deploy a virtual machine
az deployment group create -f deploy-vm.bicep -g $RESOURCE_GROUP
```

deploy後 [Container Insightsメトリックを有効にする](https://docs.microsoft.com/ja-jp/azure/azure-monitor/containers/container-insights-update-metrics)

```bash
az aks show -g <resourceGroupName> -n <clusterName> 
az role assignment create --assignee <clientIdOfSPN> --scope <clusterResourceId> --role "Monitoring Metrics Publisher" 
```

clientIdOfSPNOrMsi の値を取得するには、次の例に示すように、コマンド az aks show を実行します。 servicePrincipalProfile オブジェクトに有効な clientid 値がある場合は、その値を使用できます。 そうではなく、msi に設定されている場合は、addonProfiles.omsagent.identity.clientId から clientid を渡す必要があります。
clusterResourceIdは`/subscriptions/`ではじまるAKSのresource IDです。
