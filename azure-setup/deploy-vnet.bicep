@description('Application name')
param appName string = 'pgdemo'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('aks subnet name')
param aksSubnetName string = '${vnetName}-aks-subnet'
@description('aks subnet address prefix')
param aksPrefix string = '10.1.0.0/16'
@description('private link subnet name')
param privateLinkSubnetName string = '${vnetName}-private-link-subnet'
@description('private link subnet address prefix')
param privateLinkPrefix string = '10.2.0.0/16'
@description('bastion subnet name')
param bastionSubnetName string = '${vnetName}-bastion-subnet'
@description('bastion subnet address prefix')
param bastionPrefix string = '10.3.0.0/16'

var subnets = [
  {
    name: aksSubnetName
    prefix: aksPrefix
    endpointPolicy: 'Enabled'
    servicePolicy: 'Enabled'
  }
  {
    name: privateLinkSubnetName
    prefix: privateLinkPrefix
    endpointPolicy: 'Disabled'
    servicePolicy: 'Enabled'
  }
  {
    name: bastionSubnetName
    prefix: bastionPrefix
    endpointPolicy: 'Enabled'
    servicePolicy: 'Enabled'
  }
]

module vn 'templates/vnet.bicep' = {
  name: 'deploy-${vnetName}'
  params: {
    virtualNetworkName: vnetName
    subnets: subnets
    tags: {
      app: appName
    }
  }
}
