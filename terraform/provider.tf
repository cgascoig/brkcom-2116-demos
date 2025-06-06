terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "1.0.66"
    }
  }
}

provider "intersight" {
  # Configuration options
  apikey = var.intersight_api_keyid
  secretkey = var.intersight_api_key
  endpoint = var.intersight_endpoint
}