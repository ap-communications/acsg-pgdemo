@description('Specify the name of the Azure Redis Cache to create.')
param redisCacheName string

@description('Location of all resources')
param location string = resourceGroup().location

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('Specify the pricing tier of the new Azure Redis Cache.')
param redisCacheSKU string = 'Standard'

@allowed([
  'C'
  'P'
])
@description('Specify the family for the sku. C = Basic/Standard, P = Premium.')
param redisCacheFamily string = 'C'

@allowed([
  0
  1
  2
  3
  4
  5
  6
])
@description('Specify the size of the new Azure Redis Cache instance. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4)')
param redisCacheCapacity int = 1

@description('Specify a boolean value that indicates whether to allow access via non-SSL ports.')
param enableNonSslPort bool = false

@description('Specify a boolean value that indicates whether diagnostics should be saved to the specified storage account.')
param diagnosticsEnabled bool = false

@description('tags for redis cache')
param tags object = {}

resource redisCacheName_resource 'Microsoft.Cache/Redis@2020-06-01' = {
  name: redisCacheName
  location: location
  properties: {
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: '1.2'
    sku: {
      capacity: redisCacheCapacity
      family: redisCacheFamily
      name: redisCacheSKU
    }
  }
  tags: tags
}

