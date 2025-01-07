// Parameters
param keyVaultName string 
param vmCount int
param location string = 'eastus'
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
