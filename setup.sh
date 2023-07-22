#!/usr/bin/bash
# OL9 Workstation Essentials
# scripts/bootstrap.sh
# Purpose: Ensures Ansible is installed
oracle-release = "release 9"

# Ensure running as root user
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "FATAL: This script must be run as the root user" >&2
    echo "Setup:" >&2
    echo "chmod a+x ./setup.sh" >&2
    echo "sudo ./setup.sh" >&2
    exit
fi

# Ensure running on Oracle Linux or quit
if [ -f "/etc/oracle-release" ]; then
    echo "Running Oracle Linux"
    if [ $(grep $oracle-release /etc/oracle-release) == "" ]; then
      echo "FATAL: OL9 workstation essentials detected Oracle Linux, but not release 9" >&2
      cat /etc/os-release >&2
      exit
    else
      echo "INFO: Oracle Linux 9 Detected"
    fi
else 
  echo "FATAL: OL9 workstation essentials detected Oracle Linux, but not release 9" >&2
  cat /etc/os-release >&2
  exit
fi

# Ensure yum-config-manager is installed
dnf install -y yum-utils

# Ensure App Streams is enabled
dnf config-manager --enable ol9_appstream -y

# Install ansible-core
dnf install -y ansible-core

# Run the ansible playbook
ansible-playbook setup/site.yml
