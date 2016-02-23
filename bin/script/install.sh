#!/bin/bash
##param: model pi1|pi2|compute

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#

export PATH=${PI_BASE}/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:$PATH
echo $PATH

#
BUILD=${PI_BASE}/build

#
case $1 in
p1|pi1|compute)
  KERNEL=kernel
  KERNEL_CONF=bcmrpi_defconfig
  ;;
p2|pi2|*)
  KERNEL=kernel7
  KERNEL_CONF=bcm2709_defconfig
  ;;
esac

echo ${KERNEL}
echo ${KERNEL_CONF}

echo "Start install `date`"

#
cd ${PI_BASE}/linux

#
#install
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=${BUILD} modules_install

scripts/mkknlimg arch/arm/boot/zImage ${BUILD}/boot/${KERNEL}.img
cp arch/arm/boot/dts/*.dtb ${BUILD}/boot/
cp arch/arm/boot/dts/overlays/*.dtb* ${BUILD}/boot/overlays/
cp arch/arm/boot/dts/overlays/README ${BUILD}/boot/overlays/

#
echo "Copying custom build changes ${PI_BASE}/my/build"
cp -v -R ${PI_BASE}/my/build/* ${PI_BASE}/build/

#
echo "Calling my/install.sh"
if [ -f ${PI_BASE}/my/install.sh ]; then
	bash ${PI_BASE}/my/install.sh ${BUILD}
fi

echo "End install `date`"
##
