# resource "aap_inventory" "demo_inventory" {
#   name        = var.inventory_name_tf
#   description = "Inventory created by Terraform for AAP demo."
# }

locals {
  # extract ip from aap_controller_url
  aap_controller_ip = regex("https?://([^:/]+)", var.aap_controller_url)[0]
}

resource "terraform_data" "run_playbook_on_aap_server" {

  connection {
    type        = "ssh"
    user        = "cstella"
    private_key = var.aap_server_ssh_private_key
    host        = local.aap_controller_ip
  }

  provisioner "file" {
    source      = "${path.module}/files/configure_aap_job_template.yml"
    destination = "configure_aap_job_template.yml"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/run_playbook_on_aap_server.sh"
  }

  provisioner "remote-exec" {
    inline = [ "ansible-playbook -i 'localhost,' -c local -e \"inventory_name_for_jt='${var.inventory_name_tf}' aap_organization_name='${var.aap_organization_name}' aap_controller_host='${var.aap_controller_url}' aap_controller_username='${var.aap_controller_username}' aap_controller_password='${var.aap_controller_password}' aap_validate_certs='${var.aap_validate_certs}' project_name_for_playbook='${var.project_name_for_playbook}' machine_credential_name='${var.machine_credential_name}' machine_credential_private_key='${var.machine_credential_private_key}' machine_credential_username='${var.machine_credential_username}' job_template_name_from_playbook='${var.job_template_name_from_playbook}' machine_credential_name='${var.machine_credential_name}'\" configure_aap_job_template.yml" ]
  }
}

data "http" "job_template_id" {
  url = "${var.aap_controller_url}/api/controller/v2/job_templates/?name=${var.job_template_name_from_playbook}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure   = true
  depends_on = [terraform_data.run_playbook_on_aap_server]
}

data "http" "inventory_id" {
  url = "${var.aap_controller_url}/api/controller/v2/inventories/?name=${var.inventory_name_tf}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure   = true
  depends_on = [terraform_data.run_playbook_on_aap_server]
}

output "job_template_id" {
  value = jsondecode(data.http.job_template_id.response_body)["results"][0]["id"]
}

output "inventory_id" {
  value = jsondecode(data.http.inventory_id.response_body)["results"][0]["id"]
}
