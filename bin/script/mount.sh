#!/bin/bash

DESC=$PI_BASE/work/custom.desc
IMAGE=$PI_BASE/work/custom.img
MOUNT_POINT=$PI_BASE/build

echo $@
echo "Start mount"

if [ ! -f $IMAGE ] || [ ! -f $DESC ]; then
	echo "Image $IMAGE or descriptor $DESC  does not exist, did you run 'pi setimage <distro>'?"
	exit 1
fi

#
python $PI_SCRIPT/mount.py $IMAGE $DESC $MOUNT_POINT

echo "End mount"
##
