@description('Application name')
param appName string = 'redisdemo'
@description('redis name')
param redisName string = '${appName}-redis'

module redis 'templates/redis.bicep' = {
  name: 'deploy-${redisName}'
  params: {
    redisCacheName: redisName
    tags: {
      app: appName
    }
  }
}
