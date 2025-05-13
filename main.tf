# 1. Create an inventory in AAP
resource "aap_inventory" "demo_inventory" {
  name            = var.inventory_name_tf
  organization_id = data.aap_organization.default.id # Assumes organization "Default" or one specified by var.aap_organization_name
  description     = "Inventory created by Terraform for AAP demo."
}

data "aap_organization" "default" {
  name = var.aap_organization_name
}

# 2. Add the EC2 instance as a host to the inventory
resource "aap_host" "ec2_host" {
  name         = "ec2-instance-${var.ec2_instance_address}" # Giving a unique name based on address
  description  = "EC2 instance managed by Terraform"
  inventory_id = aap_inventory.demo_inventory.id
  variables = jsonencode({
    ansible_host = var.ec2_instance_address
  })
  enabled = true
}

# 3. Execute the Ansible playbook to create the Project and Job Template
# This playbook uses the inventory name created above.
resource "ansible_playbook" "configure_aap_resources" {
  playbook_dir = abspath(path.module)/files # Ensures playbook path is correct
  playbook     = "configure_aap_job_template.yml"
  extra_vars = {
    aap_controller_host           = var.aap_controller_url
    aap_controller_username       = var.aap_controller_username
    aap_controller_password       = var.aap_controller_password # Note: Passing sensitive data to playbook
    aap_validate_certs            = var.aap_validate_certs
    aap_organization_name         = var.aap_organization_name
    project_name_for_playbook     = var.project_name_for_playbook
    job_template_name_from_playbook = var.job_template_name_from_playbook
    inventory_name_for_jt         = aap_inventory.demo_inventory.name # Pass the name of the TF-created inventory
  }

  # Ensure inventory exists before playbook tries to use its name for JT configuration
  depends_on = [aap_inventory.demo_inventory]
}

# 4. Launch a job using the job template (created by playbook) and inventory (created by TF)
resource "aap_job" "run_hello_world" {
  job_template_name = var.job_template_name_from_playbook # Name of JT created by Ansible
  inventory_name    = aap_inventory.demo_inventory.name   # Name of Inventory created by TF
  organization_name = var.aap_organization_name

  # This ensures the playbook has run and (hopefully) created the job template
  depends_on = [ansible_playbook.configure_aap_resources, aap_host.ec2_host]
}

output "inventory_id" {
  value = aap_inventory.demo_inventory.id
}

output "host_id" {
  value = aap_host.ec2_host.id
}

output "launched_job_id" {
  value = aap_job.run_hello_world.id
}

output "job_template_used_by_job" {
  value = aap_job.run_hello_world.job_template_name
}

output "inventory_used_by_job" {
  value = aap_job.run_hello_world.inventory_name
}

output "playbook_execution_summary" {
  value = ansible_playbook.configure_aap_resources.summary
}

