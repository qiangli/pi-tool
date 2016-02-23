#!/bin/bash

#
echo "The GNU Core Utilities are the basic file, shell and text manipulation utilities: sha1sum..."
apt-get install coreutils

#
echo "util-linux is a standard package of the Linux operating system: lsblk, findmnt..."
apt-get install util-linux

echo "GNU ddrescue is a data recovery tool. It copies data from one file or block device to another"
apt-get install gddrescue

echo "XZ Utils (previously LZMA Utils) is a set of free command-line lossless data compressors."
apt-get install xz-utils

##
