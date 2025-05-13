# Add the EC2 instance as a host to the inventory
resource "aap_host" "ec2_host" {
  name         = "ec2-instance-${var.ec2_instance_address}" # Giving a unique name based on address
  description  = "EC2 instance managed by Terraform"
  inventory_id = var.inventory_id
  variables = jsonencode({
    ansible_host = var.ec2_instance_address
  })
  enabled = true
}

# Launch a job using the job template (created by playbook) and inventory (created by TF)
resource "aap_job" "run_hello_world" {
  job_template_id = var.job_template_id
  inventory_id    = var.inventory_id

  # This ensures the playbook has run and (hopefully) created the job template
  depends_on = [ aap_host.ec2_host]
}

output "host_id" {
  value = aap_host.ec2_host.id
}

output "aap_job_status" {
  value = aap_job.run_hello_world.status
}

output "aap_job_url" {
  value = aap_job.run_hello_world.url
}