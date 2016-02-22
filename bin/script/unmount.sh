#!/bin/bash

DESC=$PI_BASE/work/custom.desc
MOUNT_POINT=$PI_BASE/build

echo $@
echo "Start unmount"

if [ ! -f $DESC ]; then
	echo "Descriptor $DESC does not exist"
	exit 1
fi

echo python $PI_SCRIPT/unmount.py $DESC $MOUNT_POINT
python $PI_SCRIPT/unmount.py $DESC $MOUNT_POINT

echo "End unmount"
##
