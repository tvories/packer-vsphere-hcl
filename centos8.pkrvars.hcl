os_version = "8"
os_family = "centos"
guest_os_type = "centos7_64Guest"
os_iso_path = "[SATAStorage] ISO/CentOS-8.2.2004-x86_64-minimal.iso"
os_iso_url = "http://mirror.mobap.edu/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso"
iso_checksum = "47AB14778C823ACAE2EE6D365D76A9AED3F95BB8D0ADD23A06536B58BB5293C0"
root_disk_size = 24000
connection_username = "vagrant"
connection_password = "vagrant"
boot_command = [
  "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos8-ks.cfg<enter><wait>"
]
