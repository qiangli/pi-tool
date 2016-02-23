#!/bin/bash
##param: device
##param: y|n no prompt
#

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi

#
confirm() {
  read -p "$1 (y/n)? "
  case ${REPLY,,} in
    y|yes) return 0;;
    n|no) return 1;;
    *) return 1;;
   esac
   return 1;
}

list_usb() {
  for device in /sys/block/*
  do
    if udevadm info --query=property --path=${device} | grep -q ^ID_BUS=usb
    then
        devpath=/dev/${device##*/}
        lsblk --list --paths --noheadings --output NAME |grep --quiet "${devpath}"; if [ $? -eq 0 ]; then
		echo ${devpath}
        fi 
    fi
  done
}

verify_usb() {
  for device in /sys/block/*
  do
    if udevadm info --query=property --path=${device} | grep -q ^ID_BUS=usb
    then
        if [ ${device##*/} == $1 ] || [ /dev/${device##*/} == $1 ]; then
          return 0 
        fi
    fi
  done
  return 1
}

check_mount() {
   local dev=/dev/${1##*/}
   findmnt -o SOURCE | grep --quiet ${dev}
   if [ $? -eq 0 ]; then
     df -h |grep ${dev} |grep -v grep
     return 1
   else
     return 0
   fi
}

flash_usb() {
   local dev=/dev/${1##*/}
   local img=${PI_BASE}/work/custom.img

   echo "Flashing ${dev} with ${img}..."
   ddrescue --synchronous --force ${img} ${dev}
}

#echo ""

#
#list usb devices if no argments
if [ $# -eq 0 ]; then
  echo "List of attached USB devices:"

  list_usb

  exit 0
fi

#verify it is a valid device
#
verify_usb $1; if [ $? -ne 0 ]; then
  echo "Not a USB device: $1"
fi

#devie is not mounted
check_mount $1; if [ $? -ne 0 ]; then
  echo "Device $1 is mounted, please unmount first and try again"
  exit 1
fi

#
if [ "x$2" != "xy" ]; then
  confirm "All data on $1 will be wiped out. Are you sure?"; if [ $? -ne 0 ]; then
    echo "Aborted"
    exit 2
  fi
fi

#flash the device
flash_usb $1

##
