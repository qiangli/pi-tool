#!/bin/bash -x

SRC_IMAGE=$PI_BASE/distro/${1%.*}.img
DESC=$PI_BASE/distro/${1%.*}.desc
WORK=$PI_BASE/work

if [ ! -f $SRC_IMAGE ] || [ ! -f $DESC]; then
	echo "Image $SRC_IMAGE or descriptor $DESC does not exist"
	exit 1
fi

#
echo "Start setimage"
#
echo "Copying $SRC_IMAGE to $WORK"
cp -v $SRC_IMAGE $WORK/custom.img

echo "Copying $DESC to $WORK"
cp -v $DESC $WORK/custom.desc

echo "End setimage"
##
