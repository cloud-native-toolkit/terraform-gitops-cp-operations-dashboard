
variable cluster_username { 
  type        = string
  description = "The username for AWS access"
}

variable "cluster_password" {
  type        = string
  description = "The password for AWS access"
}

variable "server_url" {
  type        = string
}

variable "bootstrap_prefix" {
  type = string
  default = ""
}

variable "namespace" {
  type        = string
  description = "Namespace for tools"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or kubernetes)"
}

variable "cluster_exists" {
  type        = string
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "true"
}

variable "git_token" {
  type        = string
  description = "Git token"
}

variable "git_host" {
  type        = string
  default     = "github.com"
}

variable "git_type" {
  default = "github"
}

variable "git_org" {
  default = "cloud-native-toolkit-test"
}

variable "git_repo" {
  default = "git-module-test"
}

variable "gitops_namespace" {
  default = "openshift-gitops"
}

variable "git_username" {
}



// Variables added below this line for OperationsDashboard 

variable "subscription_namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
  default     = "openshift-operators"
}

variable "cp_entitlement_key" {
  type        = string
  description = "The entitlement key required to access Cloud Pak images"
  sensitive   = true
}

variable "channel" {
  type        = string
  description = "The channel from which the AssetRepository should be installed"
  default     = "v2.5"
}

variable "catalog" {
  type        = string
  description = "The catalog source that should be used to deploy the operator"
  default     = "ibm-operator-catalog"
}

variable "catalog_namespace" {
  type        = string
  description = "The namespace where the catalog has been deployed"
  default     = "openshift-marketplace"
}

variable "license" {
  type        = string
  description = "The license string that should be used for the instance"
  default     = "CP4I"
}

variable "instance_version" {
  type        = string
  description = "The version of the Asset Repository should be installed"
  default     = "2021.4.1"
}


variable "filestorageclass" {
  type = string
  description = "For assetDataVolume we need RWX volume."
  
  default="ibmc-file-gold-gid"
  
}

variable "blockstorageclass" {
  type = string
  description = "For assetDataVolume we need RWX volume."
 
  default="ibmc-block-gold"
  
}

