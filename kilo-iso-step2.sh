#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $(readlink -f $0))
PARRENT_DIR=$(dirname ${SCRIPT_HOME})
SRC_DIR="${PARRENT_DIR}/src-iso"
NEW_DIR="${PARRENT_DIR}/new-iso"

SRC_DEB_DIR="${PARRENT_DIR}/deb-kilo"
NEW_DEB_DIR="${NEW_DIR}/kilo"

echo "========Step 2 Started========"
cd "${PARRENT_DIR}"
echo "PS - Changed to (${PARRENT_DIR})"

echo "PS - Checking directories - start"
if [[ ! -e "${SRC_DEB_DIR}" ]]; then
    echo "PS - Error: Please make sure your debs are located at "
    echo "            (${SRC_DEB_DIR})"
    exit 1
fi

if [[ -e "${NEW_DEB_DIR}" ]]; then
    rm -rf ${NEW_DEB_DIR}
    echo "PS - Old (${NEW_DEB_DIR}) removed"
fi
mkdir -p ${NEW_DEB_DIR}
echo "PS - Checking directories - finished"

echo "PS - Copying extral dpkg files to (${NEW_DEB_DIR})"
rsync -av ${SRC_DEB_DIR}/* ${NEW_DEB_DIR}

echo "PS - Generating Packages.gz"
cd ${NEW_DEB_DIR}
apt-ftparchive packages ./ > Packages
gzip -c Packages | tee Packages.gz > /dev/null

echo "========Step 2 Finished========"
