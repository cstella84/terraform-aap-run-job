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
    user        = "ec2-user"
    private_key = var.aap_server_ssh_private_key
    host        = local.aap_controller_ip
  }

  provisioner "file" {
    source      = "configure_aap_job_template.yml"
    destination = "configure_aap_job_template.yml"
  }

  provisioner "remote-exec" {
    script = "run_playbook_on_aap_server.sh"
  }
}

data "http" "job_template_id" {
  url = "${var.aap_controller_url}/api/controller/v2/job_templates/?name=${var.job_template_name_from_playbook}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure   = true
  depends_on = [ansible_playbook.configure_aap_resources]
}

data "http" "inventory_id" {
  url = "${var.aap_controller_url}/api/controller/v2/inventories/?name=${var.inventory_name_tf}"

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_controller_username}:${var.aap_controller_password}")}"
  }
  insecure   = true
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
