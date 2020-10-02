# Packer with HCL and vsphere-iso

This repo gives a few examples using the latest packer (v1.5.0+) and HCL.  HCL enables a lot of neat new abilities, but I couldn't find any examples for vsphere-iso or other non-cloud configurations.
<!-- TODO: add requirements section -->
## Usage

The `vsphere.pkr.hcl` file is the main packer configuration file.  You could break out each build into its own file (`ubuntu.pkr.hcl`, `centos.pkr.hcl`, etc) but I wanted to reuse as much code as I could during this process.

To build Ubuntu 20.04: `packer build --only vsphere-iso.ubuntu --var-file=20.04.pkrvars.hcl .`

You can target specific builds with the `--only` parameter.

Each OS family has its own `source` and `builder` block in the `vsphere.pkr.hcl` file.  Each specific OS version (IE ubuntu **20.04** or centos **8**) has its own variable file that contains the unique variables for the os.  This means that you can build Ubuntu 20.04 from the same `builder` block as Ubuntu 18.04.

A few examples:

Ubuntu 18.04: `packer build --only vsphere-iso.ubuntu --var-file=18.04.pkrvars.hcl .`

Windows Server 2019: `packer build --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`

Centos 8: `packer build -force --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`

Note the trailing `.` at the end of the command.  That is telling packer to build everything in the current directory.  This is key for any `auto.pkrvars.hcl` to be automatically populated.

## Directory Structure

`boot_config` - Stores kickstart, answerfiles, and preseed files.

```bash
boot_config/
├── 2019
│   └── Autounattend.xml
├── centos-8
│   └── centos8-ks.cfg
├── ubuntu-18.04
│   └── preseed.cfg
└── ubuntu-20.04
    ├── meta-data
    ├── preseed.cfg
    └── user-data
```

These are named as to be targeted by the packer variables `os_family` and `os_version`.  This is so you can dynamically pick the correct `boot_config` files.

`drivers` - VMware Tools drivers for Windows pvscsi driver and VMXNET3 driver.  This allows Windows to come up with storage and network without needing to have VMware Tools installed.

`scripts` - Scripts used for bootstrapping the OSes.

`root directory` - Where the actual packer files exist.

## Key files

### `vsphere.pkr.hcl`

This is where the sources and builds are defined.  Every build is triggered from this file.  It includes Ubuntu, Centos, and Windows sources and builds.

### `vsphere.auto.pkrvars.hcl`

These are variables that are loaded automatically (anything with a `.auto.pkrvars.hcl` will load automatically in the same directory) and are the same for every build.  This is where the vsphere variables are populated.

### `variables.pkr.hcl`

This is where the hcl variables are declared.  You could potentially put this at the top of your `vsphere.pkr.hcl` file, but it's good practice to keep your variables files separate.

There are some defaults defined in this file, but for the most part variables are declared in the individual OS variable files.

### Individual OS variable files

These files are specifically provided during the packer command to tell packer which build to process.  An example packer command would be: `packer build -force --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`

Note the trailing period in that command.  That is telling packer to build everything in the directory, which is required to get the `auto.pkrvars.hcl` to work correctly.  Note in that command the `--only` flag.  That tells packer to only build the `vsphere-iso.windows` source.

## Using in Docker

I maintain the [packer-with-win-update](https://github.com/tvories/packer-with-win-update) docker container.  You can run this code in docker with the following syntax:

`docker run --rm -v $(pwd):/data --workdir /data tvories/packer-with-win-update build --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`
