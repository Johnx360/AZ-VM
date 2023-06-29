# AZ VM



## Getting started

Before running the script, make sure you have installed the Terraform Azure provider and configured your Azure credentials. You can use the Azure CLI to set up your credentials by running az login.

To set up Terraform on Visual Studio Code, you need to follow these steps:

1. Install Visual Studio Code: If you haven't already, download and install Visual Studio Code from the official website. https://visualstudio.microsoft.com/downloads/

2. Install the Terraform extension: Open Visual Studio Code and navigate to the Extensions tab on the left-hand side of the screen. Search for the "Terraform" extension, and click the Install button to install it. 

3. Install Terraform: You need to have Terraform installed on your machine. You can download and install the latest version of Terraform from the official website. https://developer.hashicorp.com/terraform/downloads?ajs_aid=76bc7d88-057d-4f8d-800f-12dc0c4f9f11&product_intent=terraform

4. Create a new Terraform project: Open a new folder in Visual Studio Code where you want to create your Terraform project. Then, create a new file with the extension ".tf" and start writing your Terraform code.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli


To create a Terraform module to set up a Windows Server 2016 virtual machine on Azure, follow the steps below. This module will include necessary resources such as a virtual network, subnet, public IP address, network security group, and the Windows Server 2016 virtual machine itself. The module will be designed to be reusable and configurable.


## Directory Details
Inside this module, contains the following files:
main.tf: Contains the main Terraform configuration.
variables.tf: Contains the input variables for the module.
outputs.tf: Contains the output variables for the module.
configuration - Main.tf - contains placeholder values e.g username and password which needs to be changed as desired.

## Running
Finally, run terraform init to initialize the Terraform backend and download the required provider plugins, and terraform apply to create the resources.
This Terraform module will create a Windows Server 2016 virtual machine on Azure, along with the necessary networking components.
