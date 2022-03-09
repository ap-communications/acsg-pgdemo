@description('Application name')
param appName string = 'pgdemo'
@description('Location for resource')
param location string = resourceGroup().location

@description('ssh key name')
param keyName string = '${appName}-sshkey'

@description('ssh public key')
param publicKey string

module sshKey'bicep-templates/computes/ssh-key.bicep' = {
  name: 'deploy-${keyName}'
  params: {
    keyName: keyName
    location: location
    publicKey: publicKey
    tags: {
      app: appName
    }
  }
}
