#!/bin/bash -x

if [ "x${PI_BASE}" == "x" ]; then
  echo "PI_BASE not set"
  exit 1
fi
#

#sync linux repo and tools   
#

sync_repo() {
  cd ${PI_BASE}/$1; if [ $? -eq 0 ]; then
    git reset --hard
    git pull origin "`git branch | grep '^\* ' | sed 's/^\* //'`"
  fi
}

cleanup() {
  echo "Cleaning up work area..." 
  cd ${PI_BASE}/linux; if [ $? -eq 0 ]; then
     make clean
  fi

  rm -v -rf ${PI_BASE}/work/*
}

#
echo "Start syncing and cleaning up `date`"
start_time=`date +%s`

#
sync_repo linux
sync_repo tools

#
cleanup

#
end_time=`date +%s`
echo "Elaspsed: $(expr ${end_time} - ${start_time}) seconnds"
echo "End syncing and cleaning up `date`"
#
##
