#!/bin/bash

if [ "x{$PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#
echo "Init..."

cd ${PI_BASE}/

#tools
if [ ! -d "${PI_BASE}/tools/.git" ]; then
git clone https://github.com/raspberrypi/tools
fi

#kernel source
if [ ! -d "${PI_BASE}/linux/.git" ]; then
git clone --depth=1 https://github.com/raspberrypi/linux
fi

echo "Done"
