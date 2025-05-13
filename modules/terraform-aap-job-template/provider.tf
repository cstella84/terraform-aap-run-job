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