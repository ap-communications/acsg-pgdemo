@description('Application name')
param appName string = 'pgdemo'
@description('Location for resource')
param location string = resourceGroup().location

@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('aks subnet name')
param aksSubnetName string = '${vnetName}-aks-subnet'
@description('aks subnet address prefix')
param aksPrefix string = '10.1.0.0/16'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private endpoint network pocilies of aks subnet')
param aksEndpointPolicy string = 'Enabled'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private link service pocilies of aks subnet')
param aksServicePolicy string = 'Enabled'
@description('private link subnet name')
param privateLinkSubnetName string = '${vnetName}-private-link-subnet'
@description('private link subnet address prefix')
param privateLinkPrefix string = '10.2.0.0/16'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private endpoint network pocilies of private link subnet')
param privateLinkEndpointPolicy string = 'Disabled'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private link service pocilies of private link subnet')
param privateLinkServicePolicy string = 'Enabled'
@description('bastion subnet name')
param bastionSubnetName string = '${vnetName}-bastion-subnet'
@description('bastion subnet address prefix')
param bastionPrefix string = '10.3.0.0/16'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private endpoint network pocilies of bastion subnet')
param bastionEndpointPolicy string = 'Enabled'
@allowed([
  'Enabled'
  'Disabled'
])
@description('private link service pocilies of bastion subnet')
param bastionServicePolicy string = 'Enabled'

var subnets = [
  {
    name: aksSubnetName
    prefix: aksPrefix
    endpointPolicy: aksEndpointPolicy
    servicePolicy: aksServicePolicy
  }
  {
    name: privateLinkSubnetName
    prefix: privateLinkPrefix
    endpointPolicy: privateLinkEndpointPolicy
    servicePolicy: privateLinkServicePolicy
  }
  {
    name: bastionSubnetName
    prefix: bastionPrefix
    endpointPolicy: bastionEndpointPolicy
    servicePolicy: bastionServicePolicy
  }
]

module vn 'bicep-templates/networks/vnet.bicep' = {
  name: 'deploy-${vnetName}'
  params: {
    virtualNetworkName: vnetName
    location: location
    subnets: subnets
    tags: {
      app: appName
    }
  }
}
