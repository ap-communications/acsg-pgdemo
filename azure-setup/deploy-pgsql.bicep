@description('Application name')
param appName string = 'pgdemo'

@description('postgresql name')
param name string = '${appName}-db'

module db 'templates/postgresql.bicep' = {
  name: 'nested-${name}'
  params: {
    name: name
    adminUser: 'pgsqladmin'
    adminPassword: 'p2ssw0rd'
    skuTier: 'Basic'
  }
}
