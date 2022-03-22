##### cert ######
module "cert" {
  source = "github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert.git"
}


##### dev_cluster ######

module "dev_cluster" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-login.git"

  server_url = var.server_url
  login_user = var.cluster_username
  login_password = var.cluster_password
  login_token = ""
}


resource null_resource output_kubeconfig {

depends_on=[module.dev_cluster]

  provisioner "local-exec" {
    command = "echo '${module.dev_cluster.platform.kubeconfig}' > .kubeconfig"
  }
}


##### olm ######

module "olm" {
   source = "github.com/ibm-garage-cloud/terraform-software-olm.git" 

   depends_on=[module.dev_cluster]

   cluster_config_file = module.dev_cluster.config_file_path
   cluster_type = module.dev_cluster.platform.type_code
   cluster_version = module.dev_cluster.platform.version
   olm_version              = "0.15.1"
 }

##### gitops ######

module "gitops" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops"

  depends_on=[module.cert]

  host = var.git_host
  type = var.git_type
  org  = var.git_org
  repo = var.git_repo
  token = var.git_token
  public = true
  username = var.git_username
  gitops_namespace = var.gitops_namespace
  sealed_secrets_cert = module.cert.cert
}

resource null_resource gitops_output {
  depends_on=[module.gitops]
  provisioner "local-exec" {
  
    command = "echo -n '${module.gitops.config_repo}' > git_repo"
  }

  provisioner "local-exec" {
  depends_on=[module.gitops]
    command = "echo -n '${module.gitops.config_token}' > git_token"
  }
}



##### gitops_namespace ######
module "gitops_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace.git"

  depends_on=[module.gitops]
  

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  name = var.namespace
}

resource null_resource write_namespace {
depends_on=[module.gitops_namespace]
  provisioner "local-exec" {
    command = "echo -n '${module.gitops_namespace.name}' > .namespace"
  }
}


##### gitops-bootstrap ######
module "gitops-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-util-gitops-bootstrap.git"

  depends_on=[module.dev_cluster,module.gitops,module.cert]

  cluster_config_file = module.dev_cluster.config_file_path
  gitops_repo_url     = module.gitops.config_repo_url
  git_username        = module.gitops.config_username
  git_token           = module.gitops.config_token
  bootstrap_path      = module.gitops.bootstrap_path
  sealed_secret_cert  = module.cert.cert
  sealed_secret_private_key = module.cert.private_key
  prefix              = var.bootstrap_prefix
  kubeseal_namespace  = var.kubeseal_namespace
  create_webhook      = true
}



##### cp_catalogs ######

module "cp_catalogs" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs.git"

  depends_on = [module.gitops]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = var.cp_entitlement_key
}


##### cp4i-dependencies ######

module "cp4i-dependencies" {
  source = "github.com/cloud-native-toolkit/terraform-cp4i-dependency-management"
  depends_on = [module.olm]

  cp4i_version="2021_4_1"

}


module "gitops_module" {
  source = "./module"

  depends_on = [module.gitops-bootstrap, module.cp4i-dependencies]

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


resource null_resource write_outputs {

  depends_on = [module.gitops_module]
  provisioner "local-exec" {
    
    command = "echo \"$${OUTPUT}\" > gitops-output.json"
   

    environment = {
      OUTPUT = jsonencode({
        name        = module.gitops_module.name
        branch      = module.gitops_module.branch
        namespace   = module.gitops_module.namespace
        server_name = module.gitops_module.server_name
        layer       = module.gitops_module.layer
        layer_dir   = module.gitops_module.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_module.layer == "services" ? "2-services" : "3-applications")
        type        = module.gitops_module.type
      })
    }
  }
}