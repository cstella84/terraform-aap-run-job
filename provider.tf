terraform {
  required_providers {
    aap = {
      source  = "ansible/aap"
      # Specify a version constraint if needed, e.g., version = ">= 2.1.0"
    }
    ansible = {
      source = "ansible/ansible"
      # Specify a version constraint if needed
    }
  }
}

provider "aap" {
  controller_host  = var.aap_controller_url
  username         = var.aap_controller_username
  password         = var.aap_controller_password
  validate_certs   = var.aap_validate_certs
  request_timeout  = 120 # Optional: Increase timeout for longer operations
}