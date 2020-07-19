os_version = "20.04"
os_family = "ubuntu"
guest_os_type = "ubuntu64Guest"
os_iso_path = "[SATAStorage] ISO/ubuntu-20.04-legacy-server-amd64.iso"
os_iso_url = "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04-legacy-server-amd64.iso"`
iso_checksum = "36f15879bd9dfd061cd588620a164a82972663fdd148cce1f70d57d314c21b73"
root_disk_size = 24000
connection_username = "vagrant"
connection_password = "vagrant"
boot_command = [
  "<esc><wait>",
  "<esc><wait>",
  "<enter><wait>",
  "/install/vmlinuz",
  " auto=true",
  " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
  " locale=en_US<wait>",
  " console-setup/ask_detect=false<wait>",
  " console-setup/layoutcode=us<wait>",
  " console-setup/modelcode=pc105<wait>",
  " debconf/frontend=noninteractive<wait>",
  " debian-installer=en_US<wait>",
  " fb=false<wait>",
  " initrd=/install/initrd.gz<wait>",
  " kbd-chooser/method=us<wait>",
  " keyboard-configuration/layout=USA<wait>",
  " keyboard-configuration/variant=USA<wait>",
  " netcfg/get_domain=vm<wait>",
  " netcfg/get_hostname=packer<wait>",
  " grub-installer/bootdev=/dev/sda<wait>",
  " noapic<wait>",
  " -- <wait>",
  "<enter><wait>"
]