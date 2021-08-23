# Setup azure resurces

```bash
# deploy resource group
az deployment sub create -f deploy-resource-group.bicep --location japaneast

# deploy log analytics workspace
az deployment group create -f deploy-workspace.bicep --resource-group $RESOURCE_GROUP

# deploy application insights
az deployment group create -f deploy-app-insights.bicep --resource-group $RESOURCE_GROUP \
   --parameters administratorObjectId=${KEYVAULT_ADMIN_OBJECTID}


## keyvault + certificate の連携は nginx-ingress controllerを利用する場合に機能します
# deploy keyvault
az deployment group create -f deploy-keyvault.bicep -g $RESOURCE_GROUP \
   --parameters administratorObjectId=${KEYVAULT_ADMIN_OBJECTID}

az deployment group create -f deploy-pgsql-password.bicep -g $RESOURCE_GROUP \
    --parameters user=${PG_ADMIN_USER} password=${PG_ADMIN_PASSWORD}

# deploy key vault for ingress tls cert
# export DEMO_DODMAIN_NAME=
# 自己証明書を利用する場合は以下のコマンドで証明書ファイルを作成します（有効期限365日）
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out ingress-tls.crt \
    -keyout ingress-tls.key \
    -subj "/CN=${DEMO_DOMAIN_NAME}/O=ingress-tls"
openssl pkcs12 -export -inkey ingress-tls.key -in ingress-tls.crt  -out ingress-tls.pfx

# 現在certをARM templateでデプロイすることはできません
# このためコマンドラインからimportします
az keyvault certificate import --vault-name "pgdemo-keyvault" \
  --file "ingress-tls.pfx" --name "ingress-tls" --password $TLS_EXPORT_PASSWORD

# deploy virtual network
az deployment group create -f deploy-vnet.bicep --resource-group $RESOURCE_GROUP

# deploy workspace acr and aks
az deployment group create -f deploy-aks.bicep --resource-group $RESOURCE_GROUP

# deploy container insights alert
# Alertのみ更新する場合はこちらを実行してください（deploy-aks実行時にも自動的に実行されます）
az deployment group create -f deploy-aks-alert.bicep --resource-group $RESOURCE_GROUP


# deploy postgresql
az deployment group create -f deploy-pgsql.bicep \
  --resource-group $RESOURCE_GROUP

# deploy redis
az deployment group create -f deploy-redis.bicep -g $RESOURCE_GROUP

# store redis access key to key vault (execute if you create redis or update access key)
az deployment group create -f deploy-redis-keyvault.bicep -g $RESOURCE_GROUP

# deploy public ip address
az deployment group create -f deploy-ingress-ip.bicep -g $RESOURCE_GROUP

# deploy application gateway
az deployment group create -f deploy-appgw.bicep --resource-group $RESOURCE_GROUP
```

## if you need another azure environment

同じbicepテンプレートを利用して別のアプリ環境を作成する場合は、`appName`パラメータを指定することにより実現できます。

```bash
# you can create another environment with "appName" parameter
az deployment sub create \
  -f deploy-resource-group.bicep \
  -l japaneast \
  -p appName=$ANOTHER_APP_NAME \
  --confirm-with-what-if
```

その他すべてのコマンドでも同様に`-p appName=$ANOTHER_APP_NAME`を付与してください。  
`-p`オプションは`--parameters`とも記述できます。

## Setup virtual machine

踏み台用のBastion VMをホストする場合は以下を実行できます。SSH keyの複数人による管理について、現状は考慮されていません。

```bash
# generate ssh-key (ed25519 is not supported!)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_id_rsa

# store public key to azure
az deployment group create -f deploy-vm-ssh-key.bicep -g $RESOURCE_GROUP -p publicKey="$(cat ~/.ssh/azure_id_rsa.pub)"

# deploy a virtual machine
az deployment group create -f deploy-vm.bicep -g $RESOURCE_GROUP
```

```bash
az aks show -g <resourceGroupName> -n <clusterName> 
az role assignment create --assignee <clientIdOfSPN> --scope <clusterResourceId> --role "Monitoring Metrics Publisher" 
```

clientIdOfSPNOrMsi の値を取得するには、次の例に示すように、コマンド az aks show を実行します。 servicePrincipalProfile オブジェクトに有効な clientid 値がある場合は、その値を使用できます。 そうではなく、msi に設定されている場合は、addonProfiles.omsagent.identity.clientId から clientid を渡す必要があります。
clusterResourceIdは`/subscriptions/`ではじまるAKSのresource IDです。
