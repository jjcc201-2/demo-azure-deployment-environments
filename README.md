# Azure Deployment Environments Demo 

## Table of Contents

- [Purpose](#purpose)
- [Infrastructure Overview](#infrastructure-overview)
- [Prerequisites](#prerequisites)
  - [Azure Subscription Requirements](#azure-subscription-requirements)
  - [GitHub Personal Access Token](#github-personal-access-token)
- [Getting Started](#getting-started)
  - [Setting up Codespaces (Recommended)](#setting-up-codespaces-recommended)
  - [Initial Configuration](#initial-configuration)
- [Usage](#usage)
- [Cleanup](#cleanup)

---

## Purpose

This repository demonstrates the capabilities of **Azure Deployment Environments** and showcases how to provision and manage cloud-based development environments using **Terraform**. 

This demo environment creates a fully functional Azure Deployment Environments infrastructure that allows developers to spin up standardized, cloud-based infrastructure on-demand.

---

## Infrastructure Overview

This Terraform configuration deploys the following Azure resources:

- **Azure Dev Center**: Central management hub for devloper infrastructure
- **Dev Center Project**: Project workspace for development teams
- **Azure Key Vault**: Secure storage for GitHub PAT and other secrets
- **Azure AD Security Group**: Team access management
- **Role Assignments**: Proper permissions for dev center operations

---

## Prerequisites

### Azure Subscription Requirements

Before you begin, ensure you have:

1. **Azure Subscription with Owner-level access** - Required for creating resource groups, role assignments, and managing Azure Active Directory objects

2. **Azure Resource Providers Registration** - The following Azure resource providers must be registered in your subscription:
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


### GitHub Personal Access Token

You'll need a GitHub Personal Access Token (PAT) with appropriate permissions to access your GitHub repository catalog.

**Note**: This is used because with Deployment Environments, we can use config-as-code to customise our boxes beyond standard images. In production scenarios, your config-as-code would likely be stored in a private repository. A GitHub PAT would allow your Dev Center to access this repository. 

For detailed instructions, refer to the [Microsoft documentation on configuring catalogs](https://learn.microsoft.com/en-gb/azure/deployment-environments/how-to-configure-catalog?tabs=GitHubRepoPAT#create-a-personal-access-token-in-github).

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
az login
```

Follow the prompts to complete the authentication process. Ensure you're connected to the correct subscription:

```bash
az account show
```

If you need to switch subscriptions:
```bash
az account set --subscription "Your Subscription Name or ID"
```

#### 2. Environment Configuration
Copy the example environment file and configure your variables:

```bash
cp .env.example .env
```

Edit the `.env` file with your specific values:

```bash
ARM_SUBSCRIPTION_ID=your_azure_subscription_id
GITHUB_PAT=your_github_personal_access_token
GITHUB_URI=uri_of_the_github_repo
```

**Note**: the GitHub URI will be the URI of this GitHub repository. We'll be specifically targetting the **Tasks** folder which is where the config-as-code is stored. 

#### 3. User Configuration [OPTIONAL] 

This demo uses a security group for authorisation to Deployment Environments.

This approach aligns with Azure Dev Projects best practices, enabling precise control over which development teams can access specific projects and catalogs for provisioning Azure infrastructure.

By default, the user that is logged in to Azure (via step 1) is added automatically to the security group. If you would like to add more users, such as a specific developer team, you can do so by populating a users.yaml file. 

Copy the example into a new users.yaml file with the command below

```bash
cp users.yaml.example users.yaml
```

On line 28 of users.yaml, replace the line of code with the following:

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

Replace the object_id value with the object IDs of your users. Add as many users as you need to for the demo. 

#### 4. Deployment

To deploy the resources to your Azure environment, run the following script:

```bash
source ./deploy.sh
```

This will check the terraform configuration and proceed to spin up the demo resources in a brand new azure resource group.

---
## Usage

1. **Verify deployment:**
   - Check the Azure Portal for created resources
   - Verify the Dev Center is properly configured
   - Confirm the security group has appropriate access

2. **Access your Deployment Environments:**
   - Navigate to the Azure Dev Portal (devportal.microsoft.com)
   - Sign in with your Azure AD credentials
   - You should see an option in the portal to create a new environment

## Cleanup

To remove all created resources and avoid ongoing costs:

```bash
source ./destroy.sh
```

**⚠️ Warning**: This will permanently delete all resources created by this Terraform configuration.

---

**Note**: This is a demonstration repository. For production deployments, consider implementing additional security measures, monitoring, and governance policies according to your organization's requirements.