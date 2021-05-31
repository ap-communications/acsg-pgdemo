@description('Application name')
param appName string = 'pgdemo'

// dependency exists!
@description('subscription id for workspace')
param subscriptionId string = subscription().subscriptionId
@description('Kubernetes cluster name')
param aksClusterName string = appName

@description('workspace sku')
param workspaceSku string = 'Free'

var workspaceNamePrefix = aksClusterName
var workspaceName = '${workspaceNamePrefix}-${subscriptionId}'

module workspace 'bicep-templates//monitors/workspace.bicep' = {
  name: 'nested-workspace-${appName}'
  params: {
    workspaceNamePrefix: aksClusterName
    sku: workspaceSku
    tags: {
      app: appName
    }
  }
}
