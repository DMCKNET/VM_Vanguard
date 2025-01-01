param adminUsername string
@secure()
param adminPassword string
param vmCount int
param location string

module network 'network.bicep' = {
  name: 'NetworkModule'
  scope: resourceGroup()
  params: {
    location: location
  }
}

module vm 'vm.bicep' = {
  name: 'VmModule'
  scope: resourceGroup()
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmCount: vmCount
    location: location
    subnetId: network.outputs.subnetId
  }
}

