@description('Application name')
param appName string = 'pgdemo'
@description('Location for resource')
param location string = resourceGroup().location

@description('key vault name')
param keyVaultName string = '${appName}-keyvault'
@description('Administrator group/user object id')
param administratorObjectId string

module kv 'bicep-templates/securites/key-vault.bicep' = {
  name: 'deploy-${keyVaultName}'
  params: {
    name: keyVaultName
    location: location
    principalIds: [
      {
        id: administratorObjectId
        admin: true
      }
    ]
    tags:{
      app: appName      
    }
  }
}
