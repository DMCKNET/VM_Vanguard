// Parameters
@secure()
@description('Administrator username for VMs')
param adminUsername string

@secure()
@description('Administrator password for VMs')
param adminPassword string

@description('Number of VMs to deploy')
param vmCount int

@description('Location for the deployment')
param location string = 'eastus'

@description('ID of the subnet to which VMs will be attached')
param subnetId string

// Public IP resource
resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = [for i in range(0, vmCount): {
  name: 'myPublicIP${i}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: 'myuniquepublicip${i}'
    }
  }
}]

// Network Interface resource
resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = [for i in range(0, vmCount): {
  name: 'myNIC${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp[i].id
          }
        }
      }
    ]
  }
}]

// Virtual Machine resource
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = [for i in range(0, vmCount): {
  name: 'myVM${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i].id
        }
      ]
    }
  }
}]

// Outputs
output vmIds array = [for i in range(0, vmCount): vm[i].id]
