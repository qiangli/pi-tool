#!/bin/bash

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#

DESC=${PI_BASE}/work/custom.json
IMAGE=${PI_BASE}/work/custom.img
MOUNT_POINT=${PI_BASE}/build

#echo $@

if [ ! -f ${IMAGE} ] || [ ! -f ${DESC} ]; then
	echo "Image ${IMAGE} or descriptor ${DESC} does not exist"
	exit 1
fi

echo "Mounting ${IMAGE} at ${MOUNT_POINT}"

#
mkdir -p ${MOUNT_POINT}

python ${PI_SCRIPT}/mount.py ${IMAGE} ${DESC} ${MOUNT_POINT}; if [ $? -ne 0 ]; then
    echo "Mount failed"
    exit 1
fi

echo "Mounted"
##
