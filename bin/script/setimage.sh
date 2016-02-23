#!/bin/bash
## param: image id

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi

#
normalize_image_id() {
  if [ "${1##*.}" == "desc" ]; then
    echo "${1%.*}"
  else
    echo "$1"
  fi
}

IMAGE_ID=$(normalize_image_id $1)
SRC_IMAGE=${PI_BASE}/image/${IMAGE_ID}.img
DESC=${PI_BASE}/distro/${IMAGE_ID}.json
WORK=${PI_BASE}/work

mkdir -p ${WORK}

#
if [ ! -f ${DESC} ]; then
	echo "Descriptor ${DESC} does not exist"
	exit 1
fi

if [ ! -f ${SRC_IMAGE} ]; then
	bash ${PI_SCRIPT}/extract.sh ${IMAGE_ID}; if [ $? -ne 0 ]; then
		echo "Failed to setimage because of corrupted image archive"
		exit 1
	fi
fi
#
echo "Copying ${SRC_IMAGE} to ${WORK}"
cp -v ${SRC_IMAGE} ${WORK}/custom.img

echo "Copying ${DESC} to ${WORK}"
cp -v ${DESC} ${WORK}/custom.json

echo "Done"
##
