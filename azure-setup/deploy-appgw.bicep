@description('Application name')
param appName string = 'pgdemo'

@description('application gateway name')
param applicationGatewayName string = '${appName}-appgw'

@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-appgw-subnet'
@description('frontend IP address of application gateway')
param pipName string = '${appName}-appgw-pip'

param subnetPrefix string = '10.100.0.0/16'

module appgw 'templates/appgw.bicep' = {
  name: 'nested-appgw-${appName}'
  params: {
    applicationGatewayName: applicationGatewayName
    virtualNetworkName: vnetName
    subnetName: subnetName
    publicIpAddressName: pipName
  }
  dependsOn:[
    subnet
  ]
}

module subnet 'templates/subnet.bicep' = {
  name: 'nested-appgw-subnet-${appName}'
  params: {
    subnetName: subnetName
    vnetName: vnetName
    subnetPrefix: subnetPrefix
  }
}
