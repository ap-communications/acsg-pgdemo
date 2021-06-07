@description('Application name')
param appName string = 'pgdemo'

@description('Kubernetes cluster name')
param aksClusterName string = appName

@description('workspace sku')
param workspaceSku string = 'Free'

module workspace 'bicep-templates/monitors/workspace.bicep' = {
  name: 'nested-workspace-${appName}'
  params: {
    workspaceNamePrefix: aksClusterName
    sku: workspaceSku
    tags: {
      app: appName
    }
  }
}
