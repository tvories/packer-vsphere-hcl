# DOCKERFILE that installs packer with packer-provisioner-windows-update

FROM ubuntu

RUN mkdir /data && cd /data

# Download latest packer version and unzip
ADD https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip packer.zip
RUN apt-get update -y && apt-get install -y unzip
RUN unzip -q packer.zip -d /usr/local/bin
RUN chmod +x /usr/local/bin/packer
RUN rm packer.zip

# download, extract, delete tgz, and allow plugin to execute
ADD https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.9.0/packer-provisioner-windows-update-linux.tgz packer-provisioner-windows-update-linux.tgz
RUN tar -xzf packer-provisioner-windows-update-linux.tgz -C /usr/local/bin
RUN chmod +x /usr/local/bin/packer-provisioner-windows-update
RUN rm packer-provisioner-windows-update-linux.tgz

WORKDIR /data
ENTRYPOINT [ "/usr/local/bin/packer" ]