// settings for ACR
@description('Application name')
param appName string = 'pgdemo'
param insightsName string = '${appName}-${uniqueString('ai', resourceGroup().id)}'
param containerName string = 'spa-client'

@description('Blob storage account name for App Insights app source map')
param storeNameForAISourceMap string = '${appName}map'

module insights 'bicep-templates/monitors/app-insights.bicep' = {
  name: 'nested-${insightsName}'
  params: {
    name: insightsName
    workspaceNamePrefix: appName
    tags: {
      displayName: 'Application Insights Instance'
      app: appName
    }
  }
}

module mapStorage 'bicep-templates/storages/blob-storage.bicep' = {
  name: 'nested-${insightsName}-map'
  params: {
    accountName: storeNameForAISourceMap
    containerName: containerName
    skuName: 'Standard_LRS'
    accessTier: 'Cool'
    tags: {
      app: appName
    }
  }
}
