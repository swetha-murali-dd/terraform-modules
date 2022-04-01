variable "endpoints" {
  type = list(any)
  default = [
    {
      controller     = "api/role"
      action         = "get_all_role_templates"
      flask_migrated = false
    },
    {
      controller     = "api/role"
      action         = "clone_role_v2"
      flask_migrated = false
    },
    {
      controller     = "api/role"
      action         = "remove_user_v2"
      flask_migrated = false
    }
  ]
}

module "aaa-monitors" {
  source      = "./modules/rbac"
  endpoints   = var.endpoints
  datacenters = ["us1.staging.dog"]
  env         = "staging"
}