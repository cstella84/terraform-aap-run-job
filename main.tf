module "terraform_aap_job_template" {
  source = "./modules/terraform-aap-job-template"

  aap_controller_url              = var.aap_controller_url
  aap_controller_username         = var.aap_controller_username
  aap_controller_password         = var.aap_controller_password
  aap_validate_certs              = false
  aap_organization_name           = var.aap_organization_name
  project_name_for_playbook       = var.project_name_for_playbook
  job_template_name_from_playbook = var.job_template_name_from_playbook
  inventory_name_tf               = var.inventory_name_tf
  machine_credential_private_key  = var.machine_credential_private_key
  machine_credential_name         = var.machine_credential_name
}

module "terraform_aap_launch_job" {
  source = "./modules/terraform-aap-launch-job"

  ec2_instance_address = var.ec2_instance_address
  job_template_id      = module.terraform_aap_job_template.job_template_id
  inventory_id         = module.terraform_aap_job_template.inventory_id
}