#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $(readlink -f $0))
PARRENT_DIR=$(dirname ${SCRIPT_HOME})
SRC_ISO="ubuntu-14.04.2-server-amd64.iso"
SRC_DIR="${PARRENT_DIR}/src-iso"
NEW_DIR="${PARRENT_DIR}/new-iso"

echo "PS - Change to \"${PARRENT_DIR}\""
cd "${PARRENT_DIR}"

echo "PS - Checking directories"
mkdir -p "${SRC_DIR}"
mkdir -p "${NEW_DIR}"

echo "PS - Mounting ISO file"
mount -o loop,ro "${PARRENT_DIR}/${SRC_ISO}" "${SRC_DIR}"

echo "PS - Copying all files from ISO to new directory"
#cp -rT "${SRC_DIR}" "${NEW_DIR}"
rsync -av "${SRC_DIR}/" "${NEW_DIR}"

echo "PS - Unmounting ISO file"
umount "${SRC_DIR}"

echo "PS - Finished"
