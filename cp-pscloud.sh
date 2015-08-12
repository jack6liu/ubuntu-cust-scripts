#!/bin/bash
#
echo "-- START --"
SRC_DIR='/media/sf_D_DRIVE/My_Work/Projects/_0_Customize_Ubuntu_ISO/pscloud'
DST_DIR='/opt/custom-iso-ubuntu/new-iso/pscloud'

echo "cleaning old files ..."
rm -rf ${DST_DIR}

echo "copying new files ..."
rsync -av ${SRC_DIR}/* ${DST_DIR}

echo "-- DONE --"
