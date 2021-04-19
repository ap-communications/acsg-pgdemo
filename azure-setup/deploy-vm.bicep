@description('Application name')
param appName string = 'redisdemo'
@description('ssh-key name')
param sshKeyName string = '${appName}-sshkey'
@description('redis name')
param vmName string = '${appName}-vm'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-subnet1'

module vm 'templates/linux-vm.bicep' = {
  name: 'deploy-${vmName}'
  params: {
    virtualMachineName: vmName
    adminUsername: '${vmName}-admin'
    sshKeyName: sshKeyName
    virtualNetworkName: vnetName
    subnetName: subnetName
    tags: {
      app: appName
    }
  }
}
