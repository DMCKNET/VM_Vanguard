# VM_Vanguard
# Azure Infrastructure Deployment with Bicep

## Overview
This repository contains Bicep templates for deploying Azure infrastructure, including virtual machines, networking resources, and security groups.

## Bicep Modules

### 1. main.bicep
- **Purpose**: Orchestrates the deployment of resources.
- **Parameters**:
  - `adminUsername` (string): Administrator username for VMs.
  - `adminPassword` (securestring): Administrator password for VMs.
  - `vmCount` (int): Number of VMs to deploy.
  - `location` (string): Location for the deployment.

### 2. network.bicep
- **Purpose**: Defines networking resources like Virtual Network, Subnet, and Network Security Groups.
- **Parameters**:
  - `location` (string): Location for the deployment.

### 3. vm.bicep
- **Purpose**: Defines virtual machines and related resources.
- **Parameters**:
  - `adminUsername` (string): Administrator username for VMs.
  - `adminPassword` (securestring): Administrator password for VMs.
  - `vmCount` (int): Number of VMs to deploy.
  - `location` (string): Location for the deployment.
  - `subnetId` (string): ID of the subnet to attach VMs.

## Parameter Files

### 1. dev.parameters.json
- Example parameters for the development environment.

### 2. prod.parameters.json
- Example parameters for the production environment.

### 3. test.parameters.json
- Example parameters for the testing environment.

## Deployment Instructions
1. **Create Resource Group**:
    ```bash
    az group create --name myResourceGroup --location eastus
    ```

2. **Deploy Resources**:
    ```bash
    az deployment group create --resource-group myResourceGroup --template-file main.bicep --parameters @dev.parameters.json
    ```

## Cleanup Instructions
To delete the resource group and all its resources:
```bash
az group delete --name myResourceGroup --yes --no-wait
