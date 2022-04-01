variable "datacenter" {
    type = string
    description = "datacenter"
}

variable "flask_migrated" {
    type = bool
    description = "flask_migrated"
    default = false
}

variable "env" {
    type = string
    description = "env"
}

variable "rbac_endpoints" {
    type = list
    description = "endpoints"
}