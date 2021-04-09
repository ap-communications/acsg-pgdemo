// settings for ACR
@description('Application name')
param appName string = 'pgdemo'
@description('ACR name')
param acrName string = '${appName}acr'
@description('ACR resource group name')
param acrResourceGroupName string = resourceGroup().name
@description('ACR resource group location')
param acrLocation string = resourceGroup().location

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
param agentVMSize string = 'Standard_B2s'
@description('The mininum number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
param agentMinCount int = 2
@description('The maximum number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
param agentMaxCount int = 5

@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-subnet1'

// @description('service principal id')
// param servicePrincipalId string = 'msi'
// @description('service principal secret')
// param servicePrincipalSecret string = json('null')

// settings for Log analytics workspace
@description('workspace sku')
param workspaceSku string = 'Free'

var aksClusterVersion = '1.19.6'

module workspace 'templates/workspace.bicep' = {
  name: 'nested-workspace-${appName}'
  params: {
    workspaceNamePrefix: aksClusterName
    sku: workspaceSku
    tags: {
      app: appName
    }
  }
}

module aks 'templates/aks-cluster.bicep' = {
  name: 'nested-aks-${appName}'
  params: {
    clusterName: aksClusterName
    kubernetesVersion: aksClusterVersion
    agentVMSize: agentVMSize
    agentMinCount: agentMinCount
    agentMaxCount: agentMaxCount
    availabilityZones: aksAvailabilityZones
    workspaceId: workspace.outputs.id
    virtualNetworkName: vnetName
    subnetName: subnetName
    tags: {
      app: appName
    }
  }
}

module acrGroup 'templates/resource-group.bicep' = if(resourceGroup().name != acrResourceGroupName) {
  scope: subscription()
  name: 'neteted-rc-${acrResourceGroupName}'
  params: {
    name: acrResourceGroupName
    location: acrLocation
  }
}

module acr 'templates/acr.bicep' = {
  name: 'neteted-acr-${appName}'
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
