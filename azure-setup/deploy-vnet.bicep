@description('Application name')
param appName string = 'pgdemo'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-subnet1'

module vn 'templates/vnet.bicep' = {
  name: 'deploy-${vnetName}'
  params: {
    virtualNetworkName: vnetName
    subnetName: subnetName
    tags: {
      app: appName
    }
  }
}
