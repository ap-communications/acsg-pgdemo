// settings for ACR
@description('Application name')
param appName string = 'pgdemo'
@description('ACR name')
param acrName string = '${appName}acr'
@description('ACR resource group name')
param acrResourceGroupName string = resourceGroup().name
@description('ACR resource group location')
param acrLocation string = resourceGroup().location
@description('key vault name')
param keyVaultName string = '${appName}-keyvault'

// settings for AKS
@description('Kubernetes cluster name')
param aksClusterName string = appName
@description('Availability zone for aks')
param aksAvailabilityZones array = [
  '1'
  '2'
  '3'
]
@description('Node disk size in GB')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0
@description('VM size for agent node')
param agentVMSize string = 'Standard_B4ms'
@description('The mininum number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
param agentMinCount int = 2
@description('The maximum number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
param agentMaxCount int = 5

@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-aks-subnet'

// settings for Log analytics workspace
@description('workspace sku')
param workspaceSku string = 'Free'

@allowed([
  'azure'
  'calico'
])
@description('network plugin for network policy')
param networkPolicy string = 'azure'
@description('CIDR IP range for services')
param serviceCidr string = '172.29.0.0/16'
@description('IP address assigned to the Kubernetes DNS service. it can be inside the range of serviceCidr.')
param dnsServcieIP string = '172.29.0.10'
@description('CIDR IP range for docker bridge. It can not be the first or last address in its CIDR block')
param dockerBridgeCidr string = '172.17.0.1/16'

var aksClusterVersion = '1.19.9'

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

module aks 'bicep-templates/containers/aks-cluster.bicep' = {
  name: 'nested-aks-${appName}'
  params: {
    clusterName: aksClusterName
    kubernetesVersion: aksClusterVersion
    osDiskSizeGB: osDiskSizeGB
    agentVMSize: agentVMSize
    agentMinCount: agentMinCount
    agentMaxCount: agentMaxCount
    availabilityZones: aksAvailabilityZones
    workspaceId: workspace.outputs.id
    virtualNetworkName: vnetName
    subnetName: subnetName
    networkPolicy: networkPolicy
    serviceCidr: serviceCidr
    dnsServcieIP: dnsServcieIP
    dockerBridgeCidr: dockerBridgeCidr
    tags: {
      app: appName
    }
  }
}

module acrGroup 'bicep-templates/generals/resource-group.bicep' = if(resourceGroup().name != acrResourceGroupName) {
  scope: subscription()
  name: 'nested-rc-${acrResourceGroupName}'
  params: {
    name: acrResourceGroupName
    location: acrLocation
  }
}

module acr 'bicep-templates/containers/acr.bicep' = {
  name: 'nested-acr-${appName}'
  scope: resourceGroup(acrResourceGroupName)
  params:{
    acrName: acrName
    targetPrincipalId: aks.outputs.principalId
    tags: {
      displayName: 'Container Registory'
      clusterName: aksClusterName
    }
  }
}


resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: keyVaultName
}

module kvPolicy 'bicep-templates/securites/kv-access-policies.bicep' = {
  name: 'nested-kv-policy-aks-${aksClusterName}'
  params: {
    name: keyVaultName
    principalIds: [
      {
        id: aks.outputs.principalId
        admin: false
      }
    ]
  }
}

var readerRoleObjectId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
module readerRoleDef 'bicep-templates/generals/role-definition.bicep' = {
  name: readerRoleObjectId
  params: {
    roleId: readerRoleObjectId
  }
}

resource roleAssign 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('${keyVaultName}-${aksClusterName}-role-assign')
  scope: kv
  properties: {
    principalId: aks.outputs.principalId
    roleDefinitionId: readerRoleDef.outputs.id
  }
}
