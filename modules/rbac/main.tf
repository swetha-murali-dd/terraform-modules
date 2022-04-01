terraform {
  required_providers {
    datadog = {
      source = "Datadog/datadog"
    }
  }
}

provider "datadog" {
  api_key = "staging-api-key"
  app_key = "staging-app-key"
  api_url = "https://api.datad0g.com"
}

resource "datadog_monitor" "rbac-latency-monitor" {
  for_each = {for i, v in var.rbac_endpoints: i => v}
  name    = "[rbac] RBAC ${each.value.action} endpoint has high latency on env:${var.env} [${var.datacenter}]"
  type    = "query alert"
  query   = "avg(last_2h):avg:dd.track_api.timed.avg{datacenter:${var.datacenter},action:${each.value.action}} > 1000"
  tags    = ["env:${var.env}", "terraform:true", "team:team-aaa", "team:aaa-access", "datacenter:${var.datacenter}", "service:rbac"]
  
  message = <<EOT
# Description
RBAC ${each.value.action} endpoint has high latency on env:${var.env} [${var.datacenter}]
# Runbook
There has likely been a code performance regression. Check for changes and n+1 queries.
[Dashboard Link](https://app.datadoghq.com/dashboard/pk5-kxm-3pg/rabac-rbac--abac)
[Wiki Link](https://datadoghq.atlassian.net/wiki/spaces/AAA/pages/1839857764/Roles+Based+Access+Control+RBAC)
This monitor is managed via terraform. [Visit here](https://github.com/DataDog/terraform-config/tree/master/team-aaa) for more info.
@slack-aaa-access-ops
EOT

  monitor_thresholds {
    critical = 1000.0
  }
}

resource "datadog_monitor" "rbac-error-monitor" {
  for_each = {for i, v in var.rbac_endpoints: i => v}
  name    = "[rbac] RBAC ${each.value.action} endpoint has high errors on [${var.datacenter}]"
  type    = "metric alert"
  query   = "avg(last_5m):anomalies(sum:trace.${var.flask_migrated ? "flask" : "pylons"}.request.errors{datacenter:${var.datacenter},env:${var.env},resource_name:${each.value.controller}.${each.value.action},service:mcnulty-web}.as_rate(), 'basic', 2, direction='above') >= 1"
  tags    = ["env:${var.env}", "terraform:true", "team:team-aaa", "team:aaa-access", "datacenter:${var.datacenter}", "service:rbac"]
  
  message = <<EOT
# Description
RBAC ${each.value.action} endpoint has high errors on env:${var.env} [${var.datacenter}]
# Runbook
Look at mcnulty-web APM to track down the issue
[Dashboard Link](https://app.datadoghq.com/dashboard/pk5-kxm-3pg/rabac-rbac--abac)
[Wiki Link](https://datadoghq.atlassian.net/wiki/spaces/AAA/pages/1839857764/Roles+Based+Access+Control+RBAC)
This monitor is managed via terraform. [Visit here](https://github.com/DataDog/terraform-config/tree/master/team-aaa) for more info.
@slack-aaa-access-ops
EOT

  monitor_thresholds {
    critical = 1
  }
}