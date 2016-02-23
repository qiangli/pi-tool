#!/bin/bash

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#

DESC=${PI_BASE}/work/custom.json
MOUNT_POINT=${PI_BASE}/build

#echo $@

if [ ! -f ${DESC} ]; then
	echo "Descriptor ${DESC} does not exist"
	exit 1
fi

echo python ${PI_SCRIPT}/unmount.py ${DESC} ${MOUNT_POINT}
python ${PI_SCRIPT}/unmount.py ${DESC} ${MOUNT_POINT}; if [ $? -ne 0 ]; then
    echo "Unmount failed"
    exit 1
fi

echo "Unmounted"
##
