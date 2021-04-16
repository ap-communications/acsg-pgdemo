@description('ssh key name')
param keyName string = 'sshkey'
@description('public key string')
param publicKey string
@description('tags for ssh-key')
param tags object = {}

resource ssh 'Microsoft.Compute/sshPublicKeys@2020-12-01' = {
  name: keyName
  location: 'japaneast'
  properties: {
    publicKey: publicKey
  }
  tags: tags
}

output pubKey string = ssh.properties.publicKey
