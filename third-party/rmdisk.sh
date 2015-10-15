#!/bin/bash
 
# AUTHOR: Tommy Butler
#
# DESCRIPTION:
# Run this script to offline and delete a disk from your Linux system.  
# It should work for most people, but if you've got an old kernel it may not.
# Unless you know what you're doing, DO NOT USE THIS SCRIPT!
#
# LICENSE: Perl Artistic License - http://dev.perl.org/licenses/artistic.html
#
# DISCLAIMER AND LIMITATION OF WARRANTY:
# This software is distributed in the hope that it will be useful, but without 
# any warranty; without even the implied warranty of merchantability or fitness 
# for a particular purpose.  USE AT YOUR OWN RISK.  I ASSUME NO LIABILITY.
 
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
 
DISK=$1;
 
if [[ `id -u` -ne 0 ]];
then
   echo Run this script with root or sudo
   exit 1
fi
 
while true;
do
   [[ "$DISK" != "" ]] && break;
   read -p 'Enter the name of the disk you want to offline and delete: ' DISK
done
 
if [[ "$( expr substr $DISK 1 4 )" == '/dev' ]];
then
   DISK=$( expr substr $DISK 6 10 )
fi
 
if [[ ! -e /sys/block/$DISK ]];
then
   echo No entry for /dev/$DISK was not found in /sys/block/ - Cannot continue
   exit 1
fi
 
echo Are you sure you want to offline and delete /dev/${DISK}?
 
select yn in "Yes" "No"; do
   case $yn in
      Yes ) break;;
      No ) exit;;
   esac
done
 
echo offline > /sys/block/$DISK/device/state
 
echo 1 > /sys/block/$DISK/device/delete
 
echo DONE
 
exit;