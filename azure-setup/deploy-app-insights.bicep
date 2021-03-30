// settings for ACR
@description('Application name')
param appName string = 'pgdemo'
param insightsName string = '${appName}-${uniqueString('ai', resourceGroup().id)}'

module insights 'templates/app-insights.bicep' = {
  name: 'nested-${insightsName}'
  params: {
    name: insightsName    
    tags: {
      displayName: 'Application Insights Instance'
      app: appName
    }
  }
}
