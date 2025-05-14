variable "ec2_instance_address" {
  description = "The IP address or hostname of the EC2 instance to be added to the AAP inventory."
  type        = string
}

variable "aap_controller_url" {
  description = "URL of the Ansible Automation Platform controller (e.g., https://your-aap-url)."
  type        = string
}

variable "aap_controller_username" {
  description = "Username for the Ansible Automation Platform controller."
  type        = string
  default     = "admin"
}

variable "aap_controller_password" {
  description = "Password for the Ansible Automation Platform controller."
  type        = string
  sensitive   = true
}

variable "aap_insecure_skip_verify" {
  description = "Whether to skip SSL certificate validation for the AAP controller."
  type        = bool
  default     = true
}

variable "aap_organization_name" {
  description = "The name of the organization in AAP."
  type        = string
  default     = "Default"
}

variable "project_name_for_playbook" {
  description = "Name for the project in AAP that points to the hello-world playbook repository."
  type        = string
  default     = "Ansible Hello World Git (Playbook TF)"
}

variable "job_template_name_from_playbook" {
  description = "Name for the job template in AAP that will be created by the Ansible playbook."
  type        = string
  default     = "hello-world-job"
}

variable "inventory_name_tf" {
  description = "Name for the inventory to be created by Terraform in AAP."
  type        = string
  default     = "hello-world-inventory"
}

variable "machine_credential_private_key" {
  description = "Private key for the machine credential in AAP."
  type        = string
  sensitive   = true
}

variable "machine_credential_name" {
  description = "Name of the machine credential in AAP."
  type        = string
  default     = "Terraform Demo Credential"
}

variable "machine_credential_username" {
  description = "Username for the machine credential in AAP. This is the user that will be used to connect to the EC2 instance."
  type        = string
  default     = "ubuntu"
}

variable "aap_server_ssh_private_key" {
  description = "The private key for SSH access to the AAP server"
  type        = string
  sensitive   = true
}