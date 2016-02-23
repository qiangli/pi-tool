#!/bin/bash -x
## param: model

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#
export PATH=${PI_BASE}/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:$PATH
echo $PATH

#
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

# init
bash ${PI_SCRIPT}/init.sh

#
echo "Start build"
start_date=`date`

#
echo "Calling my/build.sh"
if [ -f ${PI_BASE}/my/build.sh ]; then
	bash ${PI_BASE}/my/build.sh ${KERNEL}
fi

#
echo "Copying custom source changes ${PI_BASE}/my/linux"
cp -v -R ${PI_BASE}/my/linux/* ${PI_BASE}/linux/

#
cd ${PI_BASE}/linux

#
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${KERNEL_CONF}

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

#
end_date=`date`
start_time=`date --date="$start_date" +%s`
end_time=`date --date="$end_date" +%s`

mkdir -p ${PI_BASE}/my/build

echo
echo "Build started: ${start_date}  ended: ${end_date} elapsed: $(expr ${end_time} - ${start_time}) seconds" | tee ${PI_BASE}/my/build/build.log
echo "End build"
##
