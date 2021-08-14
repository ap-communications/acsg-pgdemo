@description('Application name')
param appName string = 'pgdemo'
@description('Kubernetes cluster name')
param aksClusterName string = appName

@description('name for ingress public ip')
param publicIpName string = '${appName}-ingress-ip'

module publicIPv4 'bicep-templates/networks/public-ip.bicep' = {
  name: 'deploy-${publicIpName}'
  params: {
    name: publicIpName
    skuName: 'Standard'   // same sku level as aks load balancer
  }
}

//
// assign network role to aks cluster
//

resource ipV4Resource 'Microsoft.Network/publicIPAddresses@2021-02-01' existing = {
  name: publicIpName
}

resource aks 'Microsoft.ContainerService/managedClusters@2020-12-01' existing = {
  name: aksClusterName
}
var clientIdForCluster = aks.identity.principalId

var networkContributorRoleObjectId = '4d97b98b-1d4f-4787-a291-c67834d212e7'
module querynetworkContributorRole 'bicep-templates/generals/role-definition.bicep' = {
  name: 'query-${networkContributorRoleObjectId}'
  params: {
    roleId: networkContributorRoleObjectId
  }
}

resource assignMonitorRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(publicIpName, aksClusterName, networkContributorRoleObjectId)
  scope: ipV4Resource
  properties:{
    principalId: clientIdForCluster
    roleDefinitionId: querynetworkContributorRole.outputs.id
  }
}
