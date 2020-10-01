source "vsphere-iso" "windows" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = true #TODO: Add ca to docker
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = true
  folder              = var.vcenter_folder

  # VM Settings
  ip_wait_timeout       = "45m"
  communicator          = "winrm"
  winrm_username        = var.connection_username
  winrm_password        = var.connection_password
  winrm_timeout         = "12h"
  winrm_port            = "5985"
  shutdown_command      = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_paths              = [
      var.os_iso_path
  ]
  iso_checksum          = var.iso_checksum
  vm_name               = "server-${ var.os_version }-{{ isotime \"2006-01-02\" }}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"] # Windows requires vmware tools drivers for pvscsi to work
  network_adapters {
    # For windows, the vmware tools network drivers are required to be connected by floppy before tools is installed
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  floppy_files          = [
      "./boot_config/${var.os_version}/Autounattend.xml",
      "./scripts/winrm.bat",
      "./scripts/Install-VMWareTools.ps1",
      "./drivers/"
  ]
}
source "vsphere-iso" "ubuntu" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = true #TODO: Add ca to docker
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = true
  folder              = var.vcenter_folder

  # VM Settings
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "12h"
  ssh_port              = "22"
  ssh_handshake_attempts = "20"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_paths             = [var.os_iso_path]
  iso_checksum          = var.iso_checksum
  vm_name               = "${ var.os_family }-${ var.os_version }-{{ isotime \"2006-01-02\" }}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"]
  network_adapters {
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  boot_wait             = "5s"
  boot_command          = var.boot_command
}

source "vsphere-iso" "centos" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = true #TODO: Add ca to docker
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = true
  folder              = var.vcenter_folder

  # VM Settings
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "12h"
  ssh_port              = "22"
  ssh_handshake_attempts = "20"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_paths             = [var.os_iso_path]
  iso_checksum          = var.iso_checksum
  vm_name               = "${ var.os_family }-${ var.os_version }-{{ isotime \"2006-01-02\" }}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"]
  network_adapters {
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  boot_wait             = "5s"
  boot_command          = var.boot_command
}

build {
    # Windows builds
    sources = [
        "source.vsphere-iso.windows",
    ]
    provisioner "powershell" {
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/Disable-UAC.ps1" # I re-enable UAC with ansible post deployment
        ]
    }
    provisioner "windows-update" { # This requires windows-update-provisioner https://github.com/rgl/packer-provisioner-windows-update
        pause_before = "30s"
        filters = [
            "exclude:$_.Title -like '*VMware*'",
            "exclude:$_.Title -like '*Preview*'",
            "exclude:$_.Title -like '*Defender*'",
            "include:$true"
        ]
    }
    provisioner "powershell" {
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/Remove-UpdateCache.ps1",
            "scripts/Invoke-Defrag.ps1",
            "scripts/Reset-EmptySpace.ps1"
        ]
    }
}

build {
    sources = [
        "source.vsphere-iso.ubuntu",
    ]
    provisioner "shell" {
      execute_command = "echo '${var.connection_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
      scripts = [
          "scripts/apt.sh",
          "scripts/cleanup.sh",
          "scripts/python.sh",
          "scripts/ansible.sh",
          "scripts/ubuntu-prep.sh",
          "scripts/clean-ssh-hostkeys.sh"
      ]
    }
}

build {
    sources = [
        "source.vsphere-iso.centos",
    ]
    provisioner "shell" {
      execute_command = "echo '${var.connection_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
      scripts = [
          "scripts/ansible-centos.sh",
          "scripts/vmware-centos.sh",
          "scripts/yum-update.sh",
          "scripts/cleanup-centos.sh",
          "scripts/clean-ssh-hostkeys.sh"
      ]
    }
}