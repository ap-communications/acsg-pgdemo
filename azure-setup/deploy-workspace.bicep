@description('Application name')
param appName string = 'pgdemo'
@description('Location for resource')
param location string = resourceGroup().location

@description('workspace sku')
param workspaceSku string = 'pergb2018'

module workspace 'bicep-templates/monitors/workspace.bicep' = {
  name: 'nested-workspace-${appName}'
  params: {
    location: location
    workspaceNamePrefix: appName
    sku: workspaceSku
    tags: {
      app: appName
    }
  }
}
