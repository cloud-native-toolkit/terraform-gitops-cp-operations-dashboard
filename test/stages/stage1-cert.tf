module "cert" {
  source = "github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert.git"
  depends_on = [module.dev_cluster]
}
