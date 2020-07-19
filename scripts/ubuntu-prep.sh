#!/bin/bash

# Ensure config file exists
echo "Ensuring vm-tools config exists."
sudo touch /etc/vmware-tools/tools.conf

# Tell open vm tools to ignore other NICs
echo "Ignoring other NICS vm-tools."
grep -qFs 'exclude-nics=' /etc/vmware-tools/tools.conf || sudo tee -a /etc/vmware-tools/tools.conf <<EOF
# Disable additional nics from reporting IP
[guestinfo]
exclude-nics=docker*,veth*,br*
EOF

# Fix issue with ubuntu deploying guest customizations
echo "Fixing guest customization issues."
sed -e 's@.*D /tmp 1777 root root -.*@#D /tmp 1777 root root -.@' /usr/lib/tmpfiles.d/tmp.conf | sudo tee /usr/lib/tmpfiles.d/tmp.conf

sed '/\[Unit\]/a\After=dbus.service' /lib/systemd/system/open-vm-tools.service  | sudo tee /lib/systemd/system/open-vm-tools.service
