#!/bin/sh
source /etc/os-release

THISVERSION=`echo $VERSION_ID | cut -d . -f 1`
if [ $THISVERSION -lt 8 ] ; then 
   if [ -f /usr/bin/needs-restarting ] ; then
     /usr/bin/needs-restarting -r
     if [ $? = 1 ] ; then 
         REBOOT_REQUIRED="<font color=\"red\">yes"
       else REBOOT_REQUIRED="<font color=\"green\">no"
     fi
   else
     REBOOT_REQUIRED="needs-restarting is missing"
   fi
else 
   dnf needs-restarting -r
   if [ $? = 1 ] ; then
       REBOOT_REQUIRED="<font color=\"red\">yes"
     else REBOOT_REQUIRED="<font color=\"green\">no"
   fi
fi
echo $REBOOT_REQUIRED > /tmp/reboot_required
