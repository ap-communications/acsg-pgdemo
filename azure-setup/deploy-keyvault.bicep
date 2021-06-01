@description('Application name')
param appName string = 'pgdemo'
@description('Kubernetes cluster name')
param aksClusterName string = appName
@description('keyvault name')
param keyVaultName string = '${appName}-keyvault'
@description('Administrator group/user object id')
param administratorObjectId string

module aks 'bicep-templates/containers/query-aks.bicep' = {
  name: 'query-${aksClusterName}'
  params: {
    name: aksClusterName
  }
}

module kv 'bicep-templates/securites/key-vault.bicep' = {
  name: 'deploy-${keyVaultName}'
  params: {
    name: keyVaultName
    rolePrincipalId: aks.outputs.principalId
    principalIds: [
      {
        id: aks.outputs.principalId
        admin: false
      }
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
