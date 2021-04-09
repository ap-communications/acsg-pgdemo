
@description('Specifies the Azure location where the key vault should be created.')
param location string =resourceGroup().location
@description('Tag information for vnet')
param tags object = {}
@description('Virtual network name')
param virtualNetworkName string
@description('Address prefix for virtual network')
param addressPrefix string = '10.0.0.0/8'
@description('Subnet name')
param subnetName string
@description('Subnet prefix for virtual network')
param subnetPrefix string = '10.1.0.0/16'

resource vn 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output id string = vn.id
output name string = vn.name
output subnetIds array = [
  {
    id: vn.properties.subnets[0].id
    name: vn.properties.subnets[0].name
  }
]
