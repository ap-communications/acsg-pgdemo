@description('Specify an existing log analytics workspace name for diagnostics.')
param workspaceName string = ''
@description('Specify an existing storage account name for diagnostics.')
param storageAccountName string = ''


@description('target resource name')
param resourceName string
@description('diagnostic setting name')
param diagnosticSettingName string = '${resourceName}'
@description('is diagnostic setting enabled')
param isEnabled bool

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = {
  name:workspaceName
}

resource redis 'Microsoft.Cache/redis@2020-06-01' existing = {
  name: resourceName
}

resource diag 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: diagnosticSettingName
  properties: {
    workspaceId: empty(workspaceName)? null : workspace.id
    storageAccountId: empty(storageAccountName)? null : stg.id
    metrics: [
      {
        enabled: isEnabled
      }
    ]
  }
  scope: redis
}
