terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = ">= 1.3.0"
    }
    aap = {
      source  = "ansible/aap"
      version = ">= 1.1.2"
    }
  }
}

provider "aap" {
  host                 = var.aap_controller_url
  username             = var.aap_controller_username
  password             = var.aap_controller_password
  insecure_skip_verify = var.aap_insecure_skip_verify
  timeout              = 120 # Optional: Increase timeout for longer operations
}