#!/bin/bash -x

export PATH=$PI_BASE/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:$PATH
echo $PATH

#
#
case $1 in
pi1|compute)
  KERNEL=kernel
  KERNEL_CONF=bcmrpi_defconfig
  ;;
pi2|*)
  KERNEL=kernel7
  KERNEL_CONF=bcm2709_defconfig
  ;;
esac

echo $KERNEL
echo $KERNEL_CONF

echo "Start build `date`"

echo "Calling my/build.sh"
if [ -f $PI_BASE/my/build.sh ]; then
	bash $PI_BASE/my/build.sh $KERNEL
fi

#
echo "Copying custom source changes $PI_BASE/my/linux"
cp -v -R $PI_BASE/my/linux/* $PI_BASE/linux/

#
cd $PI_BASE/linux

#
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $KERNEL_CONF

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

#
echo "End build `date`"
##
