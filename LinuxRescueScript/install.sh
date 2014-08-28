#!/bin/bash

BKP_FILE=full_server.tar.gz

MNT_POINT=/tmp/cdrom/rescue
CHROOT_DIR=/tmp/chroot

# function to check error
function check_erro(){

    local X=${1}

    if [ ${X}x != "0x" ]; then
        echo "ERROR: Aborting ..."
        exit 99
    else
        echo "OK: Forward to next step"
    fi

}

# function to create and mount filesystem
function create_filesystem(){

    local TYPE=${1}
    local LABEL=${2}
    local DEVICE=${3}
    local MOUNT_POINT=${4}
    local OPTIONS=${5}

    if [ "${TYPE}x" = "swapx" ]; then
        echo "-> Create swap area in ${DEVICE} with label ${LABEL}"
        /usr/sbin/mkswap -L ${LABEL} ${DEVICE} > /dev/null 2>&1
        check_erro ${?}
    fi
    if [ "${TYPE}x" = "ext3x" ]; then
        echo "-> Create filesystem in ${DEVICE} with label ${LABEL}"
        /usr/sbin/mkfs.ext3 ${OPTIONS} -L ${LABEL} ${DEVICE} > /dev/null 2>&1
        check_erro ${?}

        echo "-> Mount partition ${DEVICE} in ${CHROOT_DIR}/${MOUNT_POINT}"
        /usr/bin/mkdir ${CHROOT_DIR}/${MOUNT_POINT} > /dev/null 2>&1
        /usr/bin/mount ${DEVICE} ${CHROOT_DIR}/${MOUNT_POINT} > /dev/null 2>&1
        check_erro ${?}
    fi

}

echo "###################################################"
echo "###################################################"
echo "          ATTENTION ALL DATA WILL BE LOST          "
echo "###################################################"
echo "###################################################"
echo
echo -n "CONTINUE? (Y/N): "
read reply
if [ "$reply" != "Y" ]; then
   exit 99
fi
/usr/bin/clear

# drop partition table
echo "-> Clear disk /dev/sda"

/usr/bin/dd if=/dev/zero of=/dev/sda bs=1M count=1 > /dev/null 2>&1
check_erro ${?}

# create partion table
echo "-> Create partition table in /dev/sda"

/usr/sbin/fdisk /dev/sda < ${MNT_POINT}/fdisk.input > /dev/null 2>&1
check_erro ${?}

# sleep needed to udev make devices in poor machines ...
sleep 2

# create and mount /

TYPE=ext3
LABEL=/1
DEVICE=/dev/sda2
MOUNT_POINT=/
OPTIONS=

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
#--

# create and mount /boot

TYPE=ext3
LABEL=/boot
DEVICE=/dev/sda1
MOUNT_POINT=/boot
OPTIONS="-I 128"

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
# --

# create swap area
TYPE=swap
LABEL=SWAP-sda3
DEVICE=/dev/sda3
MOUNT_POINT=
OPTIONS=

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
#--

# create and mount /usr

TYPE=ext3
LABEL=/home
DEVICE=/dev/sda5
MOUNT_POINT=/home
OPTIONS=

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
#--

# create and mount /usr

TYPE=ext3
LABEL=/usr
DEVICE=/dev/sda6
MOUNT_POINT=/usr
OPTIONS=

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
#--

# create and mount /data

TYPE=ext3
LABEL=/data
DEVICE=/dev/sda7
MOUNT_POINT=/data
OPTIONS=

create_filesystem "${TYPE}" "${LABEL}" "${DEVICE}" "${MOUNT_POINT}" "${OPTIONS}"
#--

# unpackage backup file
echo "-> Rescue system [wait ...]"

cd ${CHROOT_DIR}
tar -xzf ${MNT_POINT}/${BKP_FILE} > /dev/null
check_erro ${?}

# update initrd
echo "-> Update initrd"

/usr/bin/mkdir   -p                      ${CHROOT_DIR}/dev
/usr/bin/mount   --rbind    /dev         ${CHROOT_DIR}/dev
/usr/bin/mkdir   -p                      ${CHROOT_DIR}/sys
/usr/bin/mount   --rbind    /sys         ${CHROOT_DIR}/sys
/usr/bin/mkdir   -p                      ${CHROOT_DIR}/proc
/usr/bin/mount   -t proc    none         ${CHROOT_DIR}/proc

/usr/sbin/chroot ${CHROOT_DIR} /sbin/mkinitrd -f /boot/initrd-2.6.18-371.el5.img 2.6.18-371.el5 > /dev/null
check_erro ${?}

# write grub in MBR
echo "-> Write GRUB in MBR"

/usr/sbin/chroot ${CHROOT_DIR} /sbin/grub-install /dev/sda
check_erro ${?}

# Reboot system
echo "-> Done, reboot in 5 seconds"

sleep 5
reboot
