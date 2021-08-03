@description('Application name')
param appName string = 'pgdemo'
@description('postgresql name')
param postgresName string = '${appName}-db'

@description('secret name for db admin user')
param userSecretName string = '${appName}-db-user'
@description('db admin user')
param user string
@description('secret name for db admin user')
param dbLoginUserSecretName string = '${appName}-db-login-user'
@description('db admin user login name')
param loginUser string = '${user}@${postgresName}'
@description('secret name for db admin password')
param passwordSecretName string = '${appName}-db-password'
@description('db password')
param password string
@description('key vault name')
param keyVaultName string = '${appName}-keyvault'

module userSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${userSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: userSecretName
    secretValue: user
  }
}

module dbUserNameSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${dbLoginUserSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: dbLoginUserSecretName
    secretValue: loginUser
  }
}

module passwordSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${passwordSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: passwordSecretName
    secretValue: password
  }
}
