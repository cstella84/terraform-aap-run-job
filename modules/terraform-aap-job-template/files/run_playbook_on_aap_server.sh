#!/usr/bin/env bash
## run_playbook_on_aap_server.sh

# extract ansible-controller-4.6.11.tar.gz from install tar
# (--strip-components removes the first 4 directories)
tar --strip-components=4 -xvf \
  /tmp/ansible-automation-platform-25-bundle.tar.gz \
  ansible-automation-platform-containerized-setup-bundle-2.5-12-x86_64/bundle/collections/certified/ansible-controller-4.6.11.tar.gz

# install ansible-controller collection locally for us
ansible-galaxy collection install ansible-controller-4.6.11.tar.gz

ansible-playbook configure_aap_job_template.yml
