@description('Application name')
param appName string = 'pgdemo'
param dbHostSecretName string = '${appName}-db-host'
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

// secret name for postgres database name
var databaseSecretName = '${appName}-db-database'
// postgres database name
var database = 'pgdemo'

module hostSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${dbHostSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: dbHostSecretName
    secretValue: postgresName
  }
}

module databaseSecret 'bicep-templates/securites/kv-secret.bicep' = {
  name: 'deploy-${databaseSecretName}-scret'
  params: {
    keyvaultName: keyVaultName
    secretName: databaseSecretName
    secretValue: database
  }
}

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
