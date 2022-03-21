module "olm" {
   source = "github.com/ibm-garage-cloud/terraform-software-olm.git" 
   cluster_config_file = module.dev_cluster.config_file_path
   cluster_type = module.dev_cluster.platform.type_code
   cluster_version = module.dev_cluster.platform.version
   olm_version              = "0.15.1"
 }