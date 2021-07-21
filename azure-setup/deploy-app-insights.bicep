// settings for ACR
@description('Application name')
param appName string = 'pgdemo'
@description('Application insights name')
param insightsName string = '${appName}-${uniqueString('ai', resourceGroup().id)}'
@description('blob storage container name for client application map')
param containerName string = 'spa-client'

@description('Blob storage account name for App Insights app source map')
param storeNameForAISourceMap string = '${appName}map'

@description('Administrator group/user object id')
param administratorObjectId string

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

var blobDataReaderObjectId = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
module blobDataReaderRef 'bicep-templates/generals/role-definition.bicep' = {
  name: blobDataReaderObjectId
  params: {
    roleId: blobDataReaderObjectId
  }
}

resource roleAssign 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('${insightsName}-map-role-assign')
  properties: {
    principalId: administratorObjectId
    roleDefinitionId: blobDataReaderRef.outputs.id
  }
}


module insights 'bicep-templates/monitors/app-insights.bicep' = {
  name: 'nested-${insightsName}'
  params: {
    name: insightsName
    workspaceNamePrefix: appName
    tags: {
      displayName: 'Application Insights Instance'
      app: appName
      // Hacked, I don't think it's official but it might be work at unminify of exception call stack
      'hidden-link:Insights.Sourcemap.Storage': '{"Uri":"${mapStorage.outputs.blobEndpoint}${containerName}"}'
    }
  }
}

