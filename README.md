# Azure Deployment Environments Demo 

## Table of Contents

- [Purpose](#purpose)
- [Infrastructure Overview](#infrastructure-overview)
- [What You'll Build](#what-youll-build)
- [Expected Costs](#expected-costs)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Setting up Codespaces (Recommended)](#setting-up-codespaces-recommended)
  - [Initial Configuration](#initial-configuration-and-deployment)
- [Usage](#usage)
- [Next Steps](#next-steps)
- [Cleanup](#cleanup)

---

## Purpose

This repository demonstrates the capabilities of **Azure Deployment Environments** and showcases how to provision and manage cloud-based development environments using **Terraform**. 

This demo environment creates a fully functional Azure Deployment Environments infrastructure that allows developers to spin up standardized, cloud-based infrastructure on-demand.

---

## Infrastructure Overview

This Terraform configuration deploys the following Azure resources:

- **Azure Dev Center**: Central management hub for developer infrastructure
- **Dev Center Project**: Project workspace for development teams
- **Azure Key Vault**: Secure storage for GitHub PAT and other secrets
- **Azure AD Security Group**: Team access management
- **Role Assignments**: Proper permissions for dev center operations

Azure Deployment Environments works by pulling in a catalog of items written in infra-as-code (Bicep, Terraform etc.). Think of this as the products that your developer will be able to spin up using Azure Deployment Environments. 

For example, you might have a catalog item to deploy an Azure Web App with a Cosmos DB database.

In a real-world enterprise environment, this catalog would likely be a private repository. Therefore, the usage of a GitHub PAT is to connect to the private repository. This PAT will be stored in the Key Vault and accessed by the Dev Center

---

## What You'll Build

By the end of this demo, you'll have:
- A fully configured Azure Dev Center
- A development project with catalog integration
- A security group for team access control
- A GitHub-connected catalog for environment templates

![Azure Deployment Environments Architecture Diagram](./assets/ade-diagram.png)

*Figure: High-level architecture of the Azure Deployment Environments demo, showing the relationships between Dev Center, Project, Key Vault, Security Group, and Catalog integration.*

[🔗 View the diagram full-size](./assets/ade-diagram.png)

## Expected Costs

This demo creates resources that may incur minimal Azure costs. Most components are in free tiers, but Key Vault operations may have small charges.

Any product you spin up via an attached catalog through Azure Deployment Environments will incur cost. 

---

## Prerequisites

### Required Azure Permissions
- **Azure Subscription**: Owner or Contributor role
- **Microsoft Entra ID**: Groups Administrator role or higher


### External Requirements
- GitHub repository with catalog
- GitHub Personal Access Token (PAT) with read-access to catalog

   If you do not already have a catalog or GitHub PAT:

   - Fork this [Microsoft quickstart repo](https://github.com/microsoft/devcenter-catalog.git)

   - Create a GitHub PAT by following the [Microsoft documentation on configuring catalogs](https://learn.microsoft.com/en-gb/azure/deployment-environments/how-to-configure-catalog?tabs=GitHubRepoPAT#create-a-personal-access-token-in-github)
   - Make sure to copy it down so you don't lose it
  

---

## Getting Started

### Setting up Codespaces (Recommended)

GitHub Codespaces provides the easiest way to work with this repository as it comes pre-configured with all necessary tools.

1. **Create a new Codespace:**
   - Navigate to the repository on GitHub
   - Click the green "Code" button
   - Select the "Codespaces" tab
   - Click "Create codespace on main"

2. **Wait for the environment to initialize** - The codespace will automatically install all required dependencies including:
   - Terraform CLI
   - Azure CLI
   - Git
   - All necessary extensions


### Initial Configuration and Deployment

Once your Codespace is running, complete these setup steps:

#### 1. Azure Authentication
Authenticate with Azure using the Azure CLI:

```bash
# Bash
az login
```

Follow the prompts to complete the authentication process. Ensure you're connected to the correct subscription:

```bash
# Bash
az account show
```

If you need to switch subscriptions:
```bash
# Bash
az account set --subscription "Your Subscription Name or ID"
```



#### 2. Resource Provider Set Up

The following Azure resource providers must be registered in your subscription:
   - `Microsoft.DevCenter` - For Azure Dev Center resources
   - `Microsoft.KeyVault` - For Key Vault secrets management
   - `Microsoft.Authorization` - For role assignments
   - `Microsoft.Resources` - For resource group management

   You can register these providers using the Azure CLI:
   ```bash
   az provider register --namespace Microsoft.DevCenter
   az provider register --namespace Microsoft.KeyVault
   az provider register --namespace Microsoft.Authorization
   az provider register --namespace Microsoft.Resources
   ```



#### 3. Environment Configuration
Copy the example environment file and configure your variables:

```bash
# Bash
cp .env.example .env
```

Edit the `.env` file with your specific values:

```bash
# Your .env file should contain:
ARM_SUBSCRIPTION_ID=your_azure_subscription_id
GITHUB_PAT=your_github_personal_access_token
GITHUB_URI=https://github.com/your-handle/repo-name.git
GITHUB_PATH=your_github_path
```

**Note**: if you're using the [Microsoft quickstart repo](https://github.com/microsoft/devcenter-catalog.git), then you would use the following values (make sure to change your handle).
```bash
# Bash
GITHUB_URI=https://github.com/<your-github-handle>/devcenter-catalog.git
GITHUB_PATH=Environment-Definitions
```


#### 4. User Configuration [OPTIONAL] 

This demo uses a security group for authorisation to Deployment Environments.

This approach aligns with Azure Dev Projects best practices, enabling precise control over which development teams can access specific projects and catalogs for provisioning Azure infrastructure.

If you would like to add more users aside from yourself, such as a specific developer team, you can do so by populating a `users.yaml` file. 

Copy the example into a new `users.yaml` file with the command below

```bash
# Bash
cp users.yaml.example users.yaml
```

On line 28 of `users.yaml`, replace the line of code with the following:

```yaml
users:
    # user 1
    - object_id: "user-object-id"
    name: "User Name"
    email: "user@example.com"
    # user 2
    - object_id: "user-object-id"
    name: "User Name"
    email: "user@example.com"
```

Replace the `object_id` value with the object IDs of your users. Add as many users as you need to for the demo. 


#### 5. Deployment

To deploy the resources to your Azure environment, run the following script:

```bash
source ./deploy.sh
```

This will check the terraform configuration and proceed to spin up the demo resources in a brand new azure resource group.

---
## Usage

1. **Check Azure Portal:**
   - Navigate to your resource group
   - Verify that a Dev Center, Dev Project and Key Vault have been created
   - Verify that your catalog has successfully synced with Dev Center

2. **Test Dev Portal Access:**
   - Go to https://devportal.microsoft.com
   - Sign in with your Azure account
   - You should see your project listed

3. **Verify Catalog Connection:**
   - In the Dev Portal, try creating a new environment
   - Your catalog items should be available

![Dev Portal Screenshot](./assets/dev-portal.png)

*Figure: Screenshot of the dev portal when a signed-in user has been given the correct permissions to use the service via Azure RBAC*

---

## Next Steps

### Attaching a Private Catalog

As mentioned in the optional pre-requisites, if you would like to attach your own private repository of catalog items and you didn't do so already, you will need to create a GitHub Personal Access Token. 

For detailed instructions on how to set this up, refer to the [Microsoft documentation on configuring catalogs](https://learn.microsoft.com/en-gb/azure/deployment-environments/how-to-configure-catalog?tabs=GitHubRepoPAT#create-a-personal-access-token-in-github).

---

## Cleanup

To remove all created resources and avoid ongoing costs:

```bash
# Bash
source ./destroy.sh
```

**⚠️ Warning**: This will permanently delete all resources created by this Terraform configuration.

---

**Note**: This is a demonstration repository. For production deployments, consider implementing additional security measures, monitoring, and governance policies according to your organization's requirements.