#!/bin/bash
# Auto-mount any USB drive by label under /mnt/usb-drives

ACTION=$1
DEVICE=$2
LABEL=$3
MOUNT_BASE="/mnt/usb-drives"

if [ "$ACTION" = "add" ]; then
    mkdir -p "$MOUNT_BASE/usb-$LABEL"
    FSTYPE=$(blkid -o value -s TYPE "$DEVICE")
    if [ -z "$FSTYPE" ]; then
        echo "No filesystem detected for $DEVICE"
        exit 0
    fi
    mount -t "$FSTYPE" "$DEVICE" "$MOUNT_BASE/usb-$LABEL"
    echo "$(date): Mounted $DEVICE ($FSTYPE) at $MOUNT_BASE/usb-$LABEL" >> /var/log/usb-automount.log
elif [ "$ACTION" = "remove" ]; then
    if mountpoint -q "$MOUNT_BASE/usb-$LABEL"; then
        umount "$MOUNT_BASE/usb-$LABEL"
        rmdir "$MOUNT_BASE/usb-$LABEL"
        echo "$(date): Unmounted $MOUNT_BASE/usb-$LABEL" >> /var/log/usb-automount.log
    fi
fi

