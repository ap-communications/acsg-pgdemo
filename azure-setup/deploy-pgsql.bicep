@description('Application name')
param appName string = 'pgdemo'

@description('postgresql name')
param name string = '${appName}-db'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-private-link-subnet'

@description('key vault name')
param keyVaultName string = '${appName}-keyvault'
@description('secret name for db admin user')
param userSecretName string = '${appName}-db-user'
@description('secret name for db admin password')
param passwordSecretName string = '${appName}-db-password'

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

module db 'bicep-templates/databases/postgresql.bicep' = {
  name: 'nested-${name}'
  params: {
    name: name
    adminUser: kv.getSecret(userSecretName)
    adminPassword: kv.getSecret(passwordSecretName)
    skuTier: 'GeneralPurpose'
    virtualNetworkName: vnetName
    subnetName: subnetName
  }
}
