#!/bin/bash
DEB_DIR="/root/offline/debs"
ARCHIVES="${DEB_DIR}/archives"
DST_DIR="/root/deb-kilo"
REMOTE_HOST="9.0.0.10"
REMOTE_DIR="/opt/custom-iso-ubuntu/deb-kilo"
REMOTE_USER="root"

if [[ -e "${DEB_DIR}" ]]; then
    echo "PS - Cleaning \"${DEB_DIR}\""
    rm -rf "${DEB_DIR}"
fi

if [[ -e "${DST_DIR}" ]]; then
    echo "PS - Cleaning \"${DST_DIR}\""
    rm -rf "${DST_DIR}"
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
        qemu-kvm kvm libvirt-bin \
        openvswitch-switch openvswitch-common \
        python-libvirt libssl-dev libffi-dev \
        virt-manager virt-viewer \
        chromium-browser \
        tmux traceroute \
        sysstat htop iotop ntop \
        ntp \
        mariadb-server python-mysqldb \
        rabbitmq-server \
        keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache \
        glance python-glanceclient \
        nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient \
        nova-compute nova-compute-qemu sysfsutils libguestfs-tools python-guestfs \
        neutron-server neutron-plugin-ml2 python-neutronclient \
        neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent \
        neutron-plugin-openvswitch-agent \
        openstack-dashboard \
        cinder-api cinder-scheduler python-cinderclient \
        cinder-volume \
        swift swift-proxy python-swiftclient python-keystoneclient python-keystonemiddleware \
        xfsprogs rsync swift-account swift-container swift-object \
        heat-api heat-api-cfn heat-engine python-heatclient \
        mongodb-server mongodb-clients python-pymongo \
        ceilometer-api ceilometer-collector ceilometer-agent-central ceilometer-agent-notification \
        ceilometer-alarm-evaluator ceilometer-alarm-notifier python-ceilometerclient \
        ceilometer-agent-compute


echo "PS - Copying all offline debs to ${DST_DIR}"
mkdir -p ${DST_DIR}
cp -f ${ARCHIVES}/*deb ${DST_DIR}/

echo "PS - Copying all offline debs to ${REMOTE_HOST}"
rsync -avuzb --progress ${DST_DIR} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}
#scp  -C -r -o StrictHostKeyChecking=no ${DST_DIR}/* ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
