#!/bin/bash
## param: image id
#

if [ "x$PI_BASE" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Missing descriptor argument"
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

if [ ! -f ${DESC} ]; then
  echo "Descriptor ${DESC} does not exist"
  exit 1
fi

mkdir -p ${PI_BASE}/download

eval "$(python ${PI_SCRIPT}/desc2env.py ${DESC})"

ARC_FILE="${PI_BASE}/download/${DESCRIPTOR['archive']}"

#algorithm hash file
verify_checksum() {
  local algorithm=$1
  local hash=$2
  local file=$3

  case ${algorithm} in
    sha1)
      echo "${hash} *${file}" | sha1sum -c -
      return $?
      ;;
    sha256)
      echo "${hash} *${file}" | sha256sum -c -
      return $?
      ;;
    md5)
      echo "${hash} *${file}" | md5sum -c -
      return $?
      ;;
  esac

  return 1 
}

download_image() {
  echo "Starting download..."
  start_date=`date`
  
  
  CMD="curl -L -o ${ARC_FILE} -C - ${DESCRIPTOR['location_0']}"
  
  echo "Executing: ${CMD}"
  
  ${CMD}
  
  end_date=`date`
  start_time=`date --date="${start_date}" +%s`
  end_time=`date --date="${end_date}" +%s`
  
  echo
  echo "Started: ${start_date}  ended: ${end_date} elapsed: $(expr ${end_time} - ${start_time}) seconds"
  echo
}
##


verify_download="verify_checksum ${DESCRIPTOR['checksum_algorithm']} ${DESCRIPTOR['checksum_hash']} ${ARC_FILE}"

#
if [ -f ${ARC_FILE} ]; then
    ${verify_download}; if [ $? -eq 0 ]; then
	echo "Image downloaded and verified"
	exit 0
    fi
fi

#
download_image

#verify
if [ ! -f ${ARC_FILE} ]; then
    echo "Failed to download the image"
    exit 1
fi
${verify_download}; if [ $? -eq 0 ]; then
	echo "Image downloaded and verified"
	exit 0
else
        echo "Image seems corrupted"
        exit 1
fi
##
