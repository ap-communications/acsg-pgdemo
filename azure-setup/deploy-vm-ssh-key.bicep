@description('Application name')
param appName string = 'pgdemo'

@description('ssh key name')
param keyName string = '${appName}-sshkey'

@description('ssh public key')
param publicKey string

module sshKey'bicep-templates/computes/ssh-key.bicep' = {
  name: 'deploy-${keyName}'
  params: {
    keyName: keyName
    publicKey: publicKey
    tags: {
      app: appName
    }
  }
}
