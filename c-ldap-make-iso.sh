#!/bin/bash
SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $(readlink -f $0))
PARRENT_DIR=$(dirname ${SCRIPT_HOME})
SRC_DIR="${PARRENT_DIR}/src-iso"
NEW_DIR="${PARRENT_DIR}/new-iso"
DEB_DIR="${PARRENT_DIR}/deb"
# For seed host
ISO_NAME="ps-ldap-ubuntu-14.04.2-server-amd64.iso"
PS_LABEL="PS Ubuntu Server with LDAPD"
# For opensource openstack icehouse
#ISO_NAME="ps-icehouse-trusty-amd64.iso"
#PS_LABEL="PS ICEHOUSE INSTALLATON CD"
echo "PS - Generating md5sum.txt"
cd ${NEW_DIR}
#md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt
find . -type f -print0 | xargs -0 md5sum > md5sum.txt
cd ..

echo "PS - Greating new ISO file "
mkisofs -r -V "${PS_LABEL}" \
              -cache-inodes \
              -J -l -b isolinux/isolinux.bin \
              -c isolinux/isolinux.cat \
              -no-emul-boot \
              -boot-load-size 4 -boot-info-table \
              -z -iso-level 4 \
              -o ./${ISO_NAME} \
              -joliet-long ${NEW_DIR}/

echo "PS - Copying new ISO file to Host"
sleep 1

cp ${ISO_NAME} /media/sf_D_DRIVE/My_ISOs/3_Ubuntu/
echo "PS - Finished"
