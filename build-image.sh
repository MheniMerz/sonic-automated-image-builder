#!/bin/bash
programname=$0

function usage {
    echo "usage: $programname ASIC_vendor"
    echo "  ASIC_vendor = broadcom | nephos | cavium | barefoot | innovium | centec | marvell | mellanox"
    exit 1
}

[[ $# -ne 1 ]] && usage

cd /home/$USER/

# install prerequisites
# ======== need to add checks if programs are already installed ========
sudo apt -y update

if ! which docker &> /dev/null; then
   sudo apt install -y docker.io
fi


if ! which python3 &< /dev/null; then
   sudo apt install -y python3-pip
fi

if ! which make&> /dev/null; then
   sudo apt install -y make
fi

sudo python3 -m pip install -U pip==9.0.3
sudo pip3 install --force-reinstall --upgrade jinja2>=2.10
sudo pip3 install j2cli

if [ ! -d /home/$USER/sonic-buildimage]; then
   git clone https://github.com/Azure/sonic-buildimage.git
fi




# Ensure the 'overlay' module is loaded on your development system
sudo modprobe overlay

# Enter the source directory
cd /home/$USER/sonic-buildimage

#remove .platform file as it causes build failure
if [ -f .platform]; then
    rm .platform
fi

# (Optional) Checkout a specific branch. By default, it uses master branch. For example, to checkout the branch 201911, use "git checkout 201911"
git checkout master

# The docker daemon binds to a Unix socket instead of a TCP port.
# Which by default is owned by the user root and other users can only access it using sudo.
# The docker daemon always runs as the root user.
# The SONiC build scripts use the docker command without sudo, so we need to add our use to the docker group
# create a Unix group called docker and add users to it (usually the group is already created when installing docker).
# When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group.
sudo groupadd docker
sudo gpasswd -a $USER docker

# apply changes without loging out

/usr/bin/newgrp docker << EONG
# newgrp creats a new subshell, we're using redirection to avoid the script exiting.
pwd
# Execute make init once after cloning the repo, or after fetching remote repo with submodule updates
make init

# Execute make configure once to configure ASIC
make configure PLATFORM=$1

# Build SONiC image
make all

EONG

