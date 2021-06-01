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
