#!/bin/bash
## param: image id
#

if [ "x$PI_BASE" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#
if [ $# -eq 0 ]; then
	echo "Missing descriptor: p extract <image>"
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
DESC=${PI_BASE}/distro/${IMAGE_ID}.json
SRC_IMAGE=${PI_BASE}/image/${IMAGE_ID}.img

mkdir -p ${PI_BASE}/image

if [ ! -f ${DESC} ]; then
  echo "Descriptor $DESC does not exist"
  exit 1
fi

eval "$(python ${PI_SCRIPT}/desc2env.py ${DESC})"
ARC_FILE="${PI_BASE}/download/${DESCRIPTOR['archive']}"

extract_image() {
	local type=$1
	local file=$2
	case ${type} in
	'application/zip')
		unzip -p ${ARC_FILE} ${file} > ${SRC_IMAGE}
		return $?
		;;
	'application/x-xz')
		unxz -v -c ${ARC_FILE} > ${SRC_IMAGE}
		return $?
		;;
	esac
	return 1
}
#

if [ ! -f ${ARC_FILE} ]; then
	bash ${PI_SCRIPT}/download.sh ${IMAGE_ID}
fi	
size=$(stat --format=%s ${ARC_FILE})
if [ ${size} -ne ${DESCRIPTOR['content_length']} ]; then
	bash ${PI_SCRIPT}/download.sh ${IMAGE_ID}
fi
	
echo "Extracting ${ARC_FILE}"

extract_image "${DESCRIPTOR['content_type']}" "${DESCRIPTOR['file']}"; if [ $? -eq 0 ]; then
	echo "Exctracted"
	exit 0
else
	echo "Failed to extract ${IMAGE_ID}"
	exit 1
fi
#
##
