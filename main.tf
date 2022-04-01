variable "rbac_endpoints" {
    type = list
    default = [
        {
            controller = "api/role"
            action = "get_all_role_templates"    
        },
        {
            controller = "api/role"
            action = "clone_role_v2"
        },
        {
            controller = "api/role"
            action = "remove_user_v2"
        }
    ]
}

module "aaa-monitors" {
    source = "./modules/rbac"
    rbac_endpoints = var.rbac_endpoints
    env = "staging"
    datacenter = "us1.staging.dog"
}