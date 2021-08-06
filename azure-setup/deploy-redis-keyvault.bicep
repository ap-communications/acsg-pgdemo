@description('Application name')
param appName string = 'pgdemo'

@description('redis name')
param redisName string = '${appName}-redis'
@description('access key of redis [primary | secondary]')
@allowed([
  'primary'
  'secondary'
])
param keyName string = 'primary'

@description('key vault name')
param keyVaultName string = '${appName}-keyvault'

param redisHostSecretName string ='${appName}-redis-host'
param redisAccessKeySecrettName string ='${appName}-redis-accesskey'

resource redis 'Microsoft.Cache/Redis@2020-06-01' existing = {
  name: redisName
}


var acceessKey = (keyName == 'primary') ? redis.listKeys().primaryKey : redis.listKeys().secondaryKey

module hostSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${redisHostSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: redisHostSecretName
    secretValue: redis.name
  }
}

module accessKeySecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${redisAccessKeySecrettName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: redisAccessKeySecrettName
    secretValue: acceessKey
  }
}
