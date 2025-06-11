data "intersight_organization_organization" "default" {
    name = "default"
}

locals {
  orgMoid = data.intersight_organization_organization.default.results[0].moid
  prefix = "cg-clus25-"
}

resource "intersight_ntp_policy" "ntp1" {
  name    = "${local.prefix}demo_ntp"
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

resource "intersight_boot_precision_policy" "boot1" {
    name = "${local.prefix}boot"
    configured_boot_mode = "Uefi"
    enforce_uefi_secure_boot = false
    boot_devices {
        enabled     = true
        name        = "hdd"
        object_type = "boot.LocalDisk"
        additional_properties = jsonencode({
        Slot = "MRAID"
        Bootloader = {
            Description = ""
            Name        = ""
            ObjectType  = "boot.Bootloader"
            Path        = ""
        }
        })
    }

    organization {
    moid   = local.orgMoid
    object_type = "organization.Organization"
  }
}

resource "intersight_server_profile" "profile1" {
    name = "${local.prefix}profile"
    tags {
        key = "ansible"
        value = "deploy"
    }

    target_platform = "FIAttached"

    policy_bucket {
        moid = intersight_ntp_policy.ntp1.moid
        object_type = intersight_ntp_policy.ntp1.object_type
    }
    policy_bucket {
        moid = intersight_boot_precision_policy.boot1.moid
        object_type = intersight_boot_precision_policy.boot1.object_type
    }

    assigned_server {
        selector = "Serial eq 'FCH2712796P'"
        object_type = "compute.Blade"
    }

    organization {
        moid   = local.orgMoid
        object_type = "organization.Organization"
    }
}