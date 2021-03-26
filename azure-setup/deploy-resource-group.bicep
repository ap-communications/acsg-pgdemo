
// this file can only be deployed at a subscription scope
targetScope = 'subscription'

@description('location for general purpose resource group')
param location string = deployment().location
@description('add suffix to name if true')
param suffixEnabled bool = true
@description('Resource group name for general purpose')
param rgName string = 'rg-pgdemo'
@description('suffix text')
param suffix string = location

var actualName = (suffixEnabled) ? '${rgName}-${suffix}' : rgName

module rg 'templates/resource-group.bicep' = {
  name: 'nested-resource-group'
  params: {
    name: actualName
    location: location
    tags: {
      app: 'pg-demo'
    }
  }
}

output id string = rg.outputs.id
output name string = actualName
