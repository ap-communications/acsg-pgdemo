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

@minValue(0)
@maxValue(6)
@description('Specify the size of the new Azure Redis Cache instance. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4)')
param redisCacheCapacity int = 1

@description('Specify a boolean value that indicates whether to allow access via non-SSL ports.')
param enableNonSslPort bool = false

@description('tags for redis cache')
param tags object = {}

@description('virtual network name')
param virtualNetworkName string

@description('subnet name')
param subnetName string

resource vn 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: '${virtualNetworkName}/${subnetName}'
}

resource redis 'Microsoft.Cache/Redis@2020-06-01' = {
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

var endpointName = '${redisCacheName}-endpoint'

module endpoint 'private-endpoint.bicep' = {
  name: 'inner-deploy-${endpointName}'
  params: {
    name: endpointName
    subnetId: subnet.id
    linkServiceConnections: [
      {
        serviceId: redis.id
        groupIds: [
          'redisCache'
        ]
      }
    ]
  }
}

var redisDomainName = 'privatelink.redis.cache.windows.net'

module dns 'private-dns.bicep' = {
  name: 'inner-deploy-dns-${redisDomainName}'
  params: {
    name: redisDomainName
    vnId: vn.id
  }
}

module dnsGroup 'private-zone-group.bicep' = {
  name: 'inner-dns-group-${redisDomainName}'
  params: {
    name: '${endpointName}/default'
    zoneIds: [
      {
        zoneName: redisDomainName
        zoneId: dns.outputs.id
      }
    ]
  }
  dependsOn: [
    redis
    endpoint
  ]
}
