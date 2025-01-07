// Parameters
@description('Name of the Key Vault')
param keyVaultName string 

@description('Number of VMs to deploy')
param vmCount int

@description('Location for the deployment')
param location string = 'eastus'

@description('Environment name (e.g., Dev, Test, Prod)')
param environment string 

// Existing Key Vault resource
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

// Variable to store the secret name for the admin username
var adminUsernameSecretName = '${environment}AdminUsername'

// Module to deploy networking resources
module network './network.bicep' = {
  name: 'NetworkModule'
  scope: resourceGroup()
  params: {
    location: location
  }
}

// Module to deploy virtual machines
module vm './vm.bicep' = {
  name: 'VmModule'
  scope: resourceGroup()
  params: {
    adminUsername: kv.getSecret(adminUsernameSecretName)
    adminPassword: kv.getSecret('vmAdminPassword')
    vmCount: vmCount
    location: location
    subnetId: network.outputs.subnetId
  }
}

// Outputs
output vnetId string = network.outputs.vnetId
output subnetId string = network.outputs.subnetId
output vmIds array = vm.outputs.vmIds
