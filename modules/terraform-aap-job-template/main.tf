# resource "aap_inventory" "demo_inventory" {
#   name        = var.inventory_name_tf
#   description = "Inventory created by Terraform for AAP demo."
# }

resource "ansible_playbook" "configure_aap_resources" {
  name     = "Create AAP Job Template"
  playbook = "${abspath(path.module)}/files/configure_aap_job_template.yml"
  extra_vars = {
    aap_controller_host             = var.aap_controller_url
    aap_controller_username         = var.aap_controller_username
    aap_controller_password         = var.aap_controller_password # Note: Passing sensitive data to playbook
    aap_validate_certs              = var.aap_validate_certs
    aap_organization_name           = var.aap_organization_name
    aap_validate_certs              = var.aap_validate_certs
    project_name_for_playbook       = var.project_name_for_playbook
    job_template_name_from_playbook = var.job_template_name_from_playbook
    inventory_name_for_jt           = var.inventory_name_tf # Pass the name of the TF-created inventory
    machine_credential_private_key  = var.machine_credential_private_key
    machine_credential_name         = var.machine_credential_name
    machine_credential_username     = var.machine_credential_username
  }
}

data "http" "job_template_id" {
  url = "${var.aap_controller_url}/api/controller/v2/job_templates/?name=${var.job_template_name_from_playbook}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure = true
  depends_on = [ansible_playbook.configure_aap_resources]
}

data "http" "inventory_id" {
  url = "${var.aap_controller_url}/api/controller/v2/inventories/?name=${var.inventory_name_tf}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure = true
  depends_on = [ansible_playbook.configure_aap_resources]
}

output "job_template_id" {
  value = jsondecode(data.http.job_template_id.response_body)["results"][0]["id"]
}

output "inventory_id" {
  value = jsondecode(data.http.inventory_id.response_body)["results"][0]["id"]
}

output "playbook_execution_summary" {
  value = ansible_playbook.configure_aap_resources.ansible_playbook_stdout
}