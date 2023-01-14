#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

df -h

echo ""
echo ""

read -p "Choose a partition to be erased (eg: /dev/sdb1): " source

clear

if ["$source" -eq ""]; then
  echo "Source must no be empty"
  exit 1
fi

{
  df -h $source --output=target | grep -vE "^Mounted"
} || {
  clear
  echo "source \"$source\" is invalid!"
  exit 1
}

echo "1) vFAT (FAT32)"
echo "2) NFTS"
echo "3) EXT4"
echo ""
read -p "Please, choose a filesystem: " fs_choice

case $fs_choice in
"1")
  mkfs.vfat $source
  exit
  ;;

"2")
  mkfs.ntfs $source
  exit
  ;;

"3")
  mkfs.ext4 $source
  exit
  ;;
esac

echo "Invalid filesystem choice!"
