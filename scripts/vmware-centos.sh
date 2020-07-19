#!/bin/bash

set -e
set -x

sudo yum -y install open-vm-tools perl

# Ensure config file exists
sudo touch /etc/vmware-tools/tools.conf

# Tell open vm tools to ignore other NICs
grep -qFs 'exclude-nics=' /etc/vmware-tools/tools.conf || sudo tee -a /etc/vmware-tools/tools.conf <<EOF
# Disable additional nics from reporting IP
[guestinfo]
exclude-nics=docker*,veth*,br*
EOF