
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

// Variables added below this line for OperationsDashboard 

variable "subscription_namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
  default     = "openshift-operators"
}

variable "entitlement_key" {
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
  
  default="portworx-rwx-gp-sc"
  
}

variable "blockstorageclass" {
  type = string
  description = "For assetDataVolume we need RWX volume."
 
  default="portworx-db2-rwo-sc"
  
}
