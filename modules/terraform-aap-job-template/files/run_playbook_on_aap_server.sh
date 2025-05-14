#!/usr/bin/env bash
## run_playbook_on_aap_server.sh

# extract ansible-controller-4.6.11.tar.gz from install tar
# (--strip-components removes the first 4 directories)
tar --strip-components=4 -xvf \
  /tmp/ansible-automation-platform-25-bundle.tar.gz \
  ansible-automation-platform-containerized-setup-bundle-2.5-12-x86_64/bundle/collections/certified/ansible-controller-4.6.11.tar.gz

# install ansible-controller collection locally for us
ansible-galaxy collection install ansible-controller-4.6.11.tar.gz

#ansible-playbook -i 'localhost,' -c local -e \"inventory_name_for_jt=${inventory_name_for_jt} aap_organization_name=${aap_organization_name}\" aap_controller_host=${aap_controller_host} aap_controller_username=${aap_controller_username} aap_controller_password=${aap_controller_password} aap_validate_certs=${aap_validate_certs} project_name_for_playbook=${project_name_for_playbook} machine_credential_name=${machine_credential_name} machine_credential_private_key=${machine_credential_private_key} machine_credential_username=${machine_credential_username} job_template_name_from_playbook=${job_template_name_from_playbook} machine_credential_name=${machine_credential_name} configure_aap_job_template.yml
