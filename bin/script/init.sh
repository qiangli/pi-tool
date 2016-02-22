#!/bin/bash


echo "Start init"

cd $PI_BASE/

#tools
if [ ! -d "$PI_BASE/tools/.git" ]; then
echo 	git clone https://github.com/raspberrypi/tools
fi

#kernel source
if [ ! -d "$PI_BASE/linux/.git" ]; then
echo	git clone --depth=1 https://github.com/raspberrypi/linux
fi

echo "End init"
