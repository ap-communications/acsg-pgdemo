@description('Application name')
param appName string = 'pgdemo'
@description('Location for resource')
param location string = resourceGroup().location

@description('redis name')
param redisName string = '${appName}-redis'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-private-link-subnet'

// dependency exists!
@description('subscription id for workspace')
param subscriptionId string = subscription().subscriptionId
@description('Kubernetes cluster name')
param aksClusterName string = appName
@description('Specify a boolean value that indicates whether diagnostics should be saved to the specified workspace.')
param diagnosticsEnabled bool = false

var workspaceNamePrefix = aksClusterName
var workspaceName = '${workspaceNamePrefix}-${subscriptionId}'

module redis 'bicep-templates/databases/redis.bicep' = {
  name: 'deploy-${redisName}'
  params: {
    redisCacheName: redisName
    location: location
    virtualNetworkName: vnetName
    subnetName: subnetName
    existingWorkspaceName: workspaceName
    diagnosticsEnabled: diagnosticsEnabled 
    tags: {
      app: appName
    }
  }
}
