# IBM Cloud Pak Operations-Dashboard module 

Module to populate a gitops repository with the Operations Dashboard operator and instance from IBM Cloud Pak for Integration. Platform Navigator must be deployed before deploying Operations Dashboard.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v15
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Catalogs - github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs.git
- namespace: github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- CP4I Dependency manager: github.com/cloud-native-toolkit/terraform-cp4i-dependency-management.git
- Plaform Navigator - github.com/cloud-native-toolkit/terraform-gitops-cp-platform-navigator.git

## Example usage

```hcl-terraform
module "gitops_module" {
  source = "./module"

  depends_on = [module.cp4i-dependencies]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  catalog = module.cp_catalogs.catalog_ibmoperators
  channel = module.cp4i-dependencies.operations_dashboard.channel
  instance_version = module.cp4i-dependencies.operations_dashboard.version
  license = module.cp4i-dependencies.operations_dashboard.license
  entitlement_key = module.cp_catalogs.entitlement_key
  #cp_entitlement_key = module.cp_catalogs.entitlement_key
  filestorageclass = var.filestorageclass
  blockstorageclass = var.blockstorageclass
}

```

