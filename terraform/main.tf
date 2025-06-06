data "intersight_organization_organization" "default" {
    name = "default"
}

locals {
  orgMoid = data.intersight_organization_organization.default.results[0].moid
}

resource "intersight_ntp_policy" "ntp1" {
  name    = "demo_ntp"
  enabled = true
  ntp_servers = [
    "10.10.10.10",
    "10.10.10.11",
    "10.10.10.12",
    "10.10.10.13"
  ]
  organization {
    moid   = local.orgMoid
    object_type = "organization.Organization"
  }
}