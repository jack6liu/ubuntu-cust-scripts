#!/bin/bash
DEB_DIR="/root/offline/debs"
DEB="/root/offline/deb"

if [[ -e "${DEB_DIR}" ]]; then
    echo "PS - Cleaning \"${DEB_DIR}\""
    rm -rf "${DEB_DIR}"
fi

if [[ -e "${DEB}" ]]; then
    echo "PS - Cleaning \"${DEB}\""
    rm -rf "${DEB}"
fi

echo "PS - Re-creating \"${DEB_DIR}\""
mkdir -p "${DEB_DIR}"
mkdir -p "${DEB}"

echo "PS - Downloading DEBs to \"${DEB_DIR}\""
apt-get install -d -o dir::cache=${DEB_DIR} \
        openssh-server build-essential \
        vlan ifenslave bridge-utils \
        lubuntu-desktop vim tightvncserver \
        qemu-kvm libvirt-bin \
        openvswitch-switch openvswitch-common \
        python-libvirt libssl-dev libffi-dev \
        virt-manager virt-viewer \
        chromium-browser \
        tmux traceroute

echo "PS - Downloading DEBs to \"${DEB}\""
cp ${DEB_DIR}/archives/*.deb ${DEB}/
echo "PS - Finished"
