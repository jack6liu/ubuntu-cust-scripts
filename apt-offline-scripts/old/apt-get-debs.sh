#!/bin/bash
DEB_DIR="/root/offline/debs"
ARCHIVES="${DEB_DIR}/archives"
DST_DIR="/root/deb"
REMOTE_HOST="9.0.0.10"
REMOTE_DIR="/opt/custom-iso-ubuntu/deb"
REMOTE_USER="root"

if [[ -e "${DEB_DIR}" ]]; then
    echo "PS - Cleaning \"${DEB_DIR}\""
    rm -rf "${DEB_DIR}"
fi

echo "PS - Re-creating \"${DEB_DIR}\""
mkdir -p "${DEB_DIR}"
echo "PS - Updating repository ..."
apt-get clean all
apt-get update -y

echo "PS - Downloading DEBs to \"${DEB_DIR}\""
apt-get -y install -d -o dir::cache=${DEB_DIR} \
        openssh-server build-essential \
        vlan ifenslave bridge-utils \
        lubuntu-desktop vim tightvncserver \
        qemu-kvm libvirt-bin \
        openvswitch-switch openvswitch-common \
        python-libvirt libssl-dev libffi-dev \
        virt-manager virt-viewer \
        chromium-browser \
        tmux traceroute \
        sysstat htop iotop ntop \
	ipmitool ack-grep silversearcher-ag 

mkdir -p ${DST_DIR}
cp -f ${ARCHIVES}/*deb ${DST_DIR}/

echo "PS - Copying all offline debs to ${REMOTE_HOST}"
scp  -C -r -o StrictHostKeyChecking=no ${DST_DIR}/* ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
