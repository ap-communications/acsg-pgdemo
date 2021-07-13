@description('Application name')
param appName string = 'pgdemo'
@description('ssh-key name')
param sshKeyName string = '${appName}-sshkey'
@description('redis name')
param vmName string = '${appName}-vm'
@description('vnet name')
param vnetName string = '${appName}-vnet'
@description('subnet name')
param subnetName string = '${vnetName}-bastion-subnet'

module vm 'bicep-templates/computes/linux-vm.bicep' = {
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
