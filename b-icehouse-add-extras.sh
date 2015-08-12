#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $(readlink -f $0))
PARRENT_DIR=$(dirname ${SCRIPT_HOME})
SRC_DIR="${PARRENT_DIR}/src-iso"
NEW_DIR="${PARRENT_DIR}/new-iso"
DEB_DIR="${PARRENT_DIR}/deb-icehouse"
EXTRAS_DIST="${NEW_DIR}/dists/stable/extras/binary-amd64"
EXTRAS_POOL="${NEW_DIR}/pool/extras"

PSCLOUD_SRC='/media/sf_D_DRIVE/My_Work/Projects/_0_Customize_Ubuntu_ISO/pscloud'
PSCLOUD_DIR="${NEW_DIR}/pscloud"

RELEASE_CONF="${SCRIPT_HOME}/apt-release.conf"
RELEASE_DIR="${NEW_DIR}/dists/trusty"

echo "PS - Change to \"${PARRENT_DIR}\""
cd "${PARRENT_DIR}"

echo "PS - Checking directories"
if [[ ! -e "${DEB_DIR}" ]]; then
    echo "Error: Please make sure your debs are located at "
    echo "       \"${DEB_DIR}\""
    exit 1
fi
echo "PS - Make sure \"${EXTRAS_DIST}\" is there"
mkdir -p "${EXTRAS_DIST}"
echo "PS - Remove old \"${EXTRAS_POOL}\" and its content"
rm -rf "${EXTRAS_POOL}"
mkdir -p "${EXTRAS_POOL}"

echo "PS - Copying all debs to \"${EXTRAS_POOL}\""
cp -v -f ${DEB_DIR}/* ${EXTRAS_POOL}

echo "PS - Cleaning old \"${PSCLOUD_DIR}\""
rm -rf ${PSCLOUD_DIR}

echo "PS - Copying pscloud resource to \"${PSCLOUD_DIR}\""
rsync -av ${PSCLOUD_SRC}/* ${PSCLOUD_DIR}

echo "PS - Updating ubuntu-keyring"
cp -v /opt/build/ubuntu-keyring*deb ${NEW_DIR}/pool/main/u/ubuntu-keyring

echo "PS - Generating Packages.gz for extras"
cd ${NEW_DIR}
apt-ftparchive packages pool/extras > dists/stable/extras/binary-amd64/Packages
gzip -c dists/stable/extras/binary-amd64/Packages | tee dists/stable/extras/binary-amd64/Packages.gz > /dev/null
#apt-ftparchive packages ${EXTRAS_POOL} | gzip > ${EXTRAS_DIST}/Packages.gz

echo "PS - Generating new Release"
cd ${NEW_DIR}
apt-ftparchive release -c ${RELEASE_CONF} dists/trusty > dists/trusty/Release

echo "PS - Generating new Release.gpg"
cd ${NEW_DIR}
#gpg -b ${RELEASE_DIR}/Release
#mv ${RELEASE_DIR}/Release.sig ${RELEASE_DIR}/Release.gpg

rm -f ${RELEASE_DIR}/Release.gpg

gpg --default-key "8D1D2CB5" --output  ${RELEASE_DIR}/Release.gpg -ba ${RELEASE_DIR}/Release
#gpg --default-key "EFE21092" --output  ${RELEASE_DIR}/Release.gpg -ba ${RELEASE_DIR}/Release
echo "PS - Finished"
