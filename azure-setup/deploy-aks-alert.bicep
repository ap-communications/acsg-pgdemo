@description('Application name')
param appName string = 'pgdemo'
@description('Kubernetes cluster name')
param aksClusterName string = appName

resource aks 'Microsoft.ContainerService/managedClusters@2020-12-01' existing = {
  name: aksClusterName
}

module containerCPUAlert 'bicep-templates/monitors/container-insights/container-cpu-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-container-cpu-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'container-cpu-alert'
    alertDescription: 'alert of contaner cpu percentage for ${aksClusterName}'
  }
}

module containerWSMemoryAlert 'bicep-templates/monitors/container-insights/container-workingset-memory-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-container-ws-memory-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'container-workingset-memory-alert'
    alertDescription: 'alert of contaner workingset memory percentage for ${aksClusterName}'
  }
}

module nodeCPUAlert 'bicep-templates/monitors/container-insights/node-cpu-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-node-cpu-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'node-cpu-alert'
    alertDescription: 'alert of node cpu percentage for ${aksClusterName}'
  }
}

module nodeDiskUsageAlert 'bicep-templates/monitors/container-insights/node-disk-usage-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-node-disk-usage-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'node-disk-usage-alert'
    alertDescription: 'alert of node disk usage percentage for ${aksClusterName}'
  }
}

module nodeNotReadyAlert 'bicep-templates/monitors/container-insights/node-not-ready.bicep' = {
  name: 'deploy-${aksClusterName}-node-not-ready-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'node-not-ready-alert'
    alertDescription: 'alert of node not ready for ${aksClusterName}'
  }
}

module nodeWSMemoryAlert 'bicep-templates/monitors/container-insights/node-workingset-memory-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-node-ws-memory-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'node-workingset-memory-alert'
    alertDescription: 'alert of node workingset memory percentage for ${aksClusterName}'
  }
}

module oomkilledAlert 'bicep-templates/monitors/container-insights/OOMKilled.bicep' = {
  name: 'deploy-${aksClusterName}-oomkilled-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'oom-killed-alert'
    alertDescription: 'alert of OOMKilled for ${aksClusterName}'
  }
}

module pvUsageAlert 'bicep-templates/monitors/container-insights/pv-usage-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-pv-usage-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'pv-usage-alert'
    alertDescription: 'alert of usage percentage of pv for ${aksClusterName}'
  }
}

module podReadyAlert 'bicep-templates/monitors/container-insights/pod-ready-percentage.bicep' = {
  name: 'deploy-${aksClusterName}-pod-ready-percentage-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'pod-ready-percentage-alert'
    alertDescription: 'alert of pod ready percentage for ${aksClusterName}'
  }
}

module podsFailedAlert 'bicep-templates/monitors/container-insights/pods-in-failed-state.bicep' = {
  name: 'deploy-${aksClusterName}-pod-failed-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'pod-in-failed-state-alert'
    alertDescription: 'alert of pods in failed state for ${aksClusterName}'
  }
}

module restartingContainerAlert 'bicep-templates/monitors/container-insights/restarting-container-count.bicep' = {
  name: 'deploy-${aksClusterName}-restarting-container-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'restarting-container-count-alert'
    alertDescription: 'alert of number of restaring container for ${aksClusterName}'
  }
}

module staleJobAlert 'bicep-templates/monitors/container-insights/stale-job-count.bicep' = {
  name: 'deploy-${aksClusterName}-stale-job-count-alert'
  params: {
    aksClusterName: aksClusterName
    clusterResourceId: aks.id
    alertName: 'stale-job-count-alert'
    alertDescription: 'alert of number of stale job for ${aksClusterName}'
  }
}
