os_version = "18.04"
os_family = "ubuntu"
guest_os_type = "ubuntu64Guest"
os_iso_url = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.3-server-amd64.iso"
os_iso_path = "[SATAStorage] ISO/ubuntu-18.04.3.iso"
iso_checksum = "7d8e0055d663bffa27c1718685085626cb59346e7626ba3d3f476322271f573e"
root_disk_size = 24000
connection_username = "vagrant"
connection_password = "vagrant"
boot_command = [
  "<enter><wait><f6><wait><esc><wait>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs>",
  "/install/vmlinuz",
  " initrd=/install/initrd.gz",
  " priority=critical",
  " locale=en_US",
  " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg", # Would be nice to make this a var
  "<enter>"
]