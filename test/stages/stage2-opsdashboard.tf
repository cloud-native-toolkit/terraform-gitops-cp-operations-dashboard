module "gitops_module" {
  source = "./module"

  depends_on = [ module.cp_catalogs,module.gitops, module.gitops_namespace, module.cp4i-dependencies]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  # Added below this line
  catalog = module.cp_catalogs.catalog_ibmoperators
  channel = module.cp4i-dependencies.operations_dashboard.channel
  instance_version = module.cp4i-dependencies.operations_dashboard.version
  license = module.cp4i-dependencies.operations_dashboard.license
  entitlement_key = module.cp_catalogs.entitlement_key
  #cp_entitlement_key = module.cp_catalogs.entitlement_key
  filestorageclass = var.filestorageclass
  blockstorageclass = var.blockstorageclass
}

