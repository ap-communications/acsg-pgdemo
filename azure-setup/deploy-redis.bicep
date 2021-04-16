@description('Application name')
param appName string = 'redisdemo'

@description('redis name')
param redisName string = '${appName}-redis'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-subnet1'

module redis 'templates/redis.bicep' = {
  name: 'deploy-${redisName}'
  params: {
    redisCacheName: redisName
    virtualNetworkName: vnetName
    subnetName: subnetName
    tags: {
      app: appName
    }
  }
}
