@description('Application name')
param appName string = 'pgdemo'

@description('postgresql name')
param name string = '${appName}-db'
@description('Administrator user name')
@secure()
param adminUser string
@description('Administrator user password')
@secure()
param adminPassword string
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-private-link-subnet'


module db 'bicep-templates/databases/postgresql.bicep' = {
  name: 'nested-${name}'
  params: {
    name: name
    adminUser: adminUser
    adminPassword: adminPassword
    skuTier: 'GeneralPurpose'
    virtualNetworkName: vnetName
    subnetName: subnetName
  }
}
