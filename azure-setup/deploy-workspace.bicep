@description('Application name')
param appName string = 'pgdemo'

@description('workspace sku')
param workspaceSku string = 'Free'

module workspace 'bicep-templates/monitors/workspace.bicep' = {
  name: 'nested-workspace-${appName}'
  params: {
    workspaceNamePrefix: appName
    sku: workspaceSku
    tags: {
      app: appName
    }
  }
}
