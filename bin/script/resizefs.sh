#!/bin/bash
  
if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi

#  
#device partition sector
#
resize_fs() {
  echo "Resizing file system $1 $2 $3"
  echo

  fdisk -l $1
  echo

  echo "fdisk $1"
  fdisk $1 << EOC
d
2
n
p
2
$3
 
w
EOC
  
  echo
  echo "e2fsck -f -t -v $1$2"
  e2fsck -f -t -v $1$2 

  echo
  echo "resize2fs -P $1$2"
  resize2fs -P $1$2

  echo
  fdisk -l $1
}
  

#
if [ $# -eq 0 ]; then
	echo "Arguments required: device"
	exit 1
fi

DESC=${PI_BASE}/work/custom.json
partition_params=`python ${PI_SCRIPT}/findpart.py ${DESC}`; if [ $? -ne 0 ]; then
	echo "Failed to find partition for resizing"
	exit 1
fi

resize_fs /dev/${1##*/} ${partition_params}

##