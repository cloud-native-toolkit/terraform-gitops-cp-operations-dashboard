module "cp4i-dependencies" {
  source = "github.com/cloud-native-toolkit/terraform-cp4i-dependency-management"
  depends_on = [module.olm]

  cp4i_version="2021_4_1"

}