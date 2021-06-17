@description('Application name')
param appName string = 'pgdemo'
@description('key vault name')
param keyVaultName string = '${appName}-keyvault'
@description('Administrator group/user object id')
param administratorObjectId string

module kv 'bicep-templates/securites/key-vault.bicep' = {
  name: 'deploy-${keyVaultName}'
  params: {
    name: keyVaultName
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
