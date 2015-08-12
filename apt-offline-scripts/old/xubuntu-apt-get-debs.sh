#!/bin/bash
DEB_DIR="/root/offline/debs"
ARCHIVES="${DEB_DIR}/archives"
DST_DIR="/root/deb-xubuntu"
REMOTE_HOST="9.0.0.10"
REMOTE_DIR="/opt/custom-iso-ubuntu/deb-xubuntu"
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
        openssh-server build-essential sshfs \
        vlan ifenslave bridge-utils \
        xubuntu-desktop xubuntu-default-settings \
        xubuntu-icon-theme xubuntu-artwork \
        vim tightvncserver remmina \
        libgnutls28 libtasn1-3-bin \
        qemu-kvm libvirt-bin \
        openvswitch-switch openvswitch-common \
        python-libvirt libssl-dev libffi-dev \
        virt-manager virt-viewer \
        chromium-browser \
        tmux traceroute \
        sysstat htop iotop ntop \
	ipmitool ack-grep silversearcher-ag \
        slapd ldap-utils \
        ntp \
        multipath-tools

echo "PS - Download completed"
mkdir -p ${DST_DIR}
cp -f ${ARCHIVES}/*deb ${DST_DIR}/

echo "PS - Copying all offline debs to ${REMOTE_HOST}"
scp  -C -r -o StrictHostKeyChecking=no ${DST_DIR}/* ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
echo "PS - Copying completed"
