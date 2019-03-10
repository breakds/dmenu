#! /bin/bash

DEFAULT_MOUNTPOINT=/media/disk

function umount() {
    mount_table=$(lsblk -rpo "name,type,size,mountpoint" | awk '$2=="part"&&$5==""{printf "%s %s\n",$1,$4}')
    mount_device=$(echo -e "${mount_table}" | grep ${DEFAULT_MOUNTPOINT} | cut -d' ' -f1)

    # If something is mounted, prompt for umount and quit.
    if [ ! -z "${mount_device}" ]; then
        proceed=$(echo -e "No\nYes" | dmenu -i -p "${DEFAULT_MOUNTPOINT} already mounted. Do you want to umount it?")
        if [ "${proceed}" = "Yes" ]; then
            sudo umount ${DEFAULT_MOUNTPOINT}
        fi
        exit
    fi
}

function mount() {
    # ---------- Step 1 ----------
    #
    # Find all the umounted block devices and choose one.
    #
    # Credits to Luke Smith: https://github.com/LukeSmithxyz/voidrice/blob/master/.scripts/i3cmds/dmenumount
    devices=$(lsblk -rpo "name,type,size,mountpoint" | awk '$2=="part"&&$4==""{printf "%s (%s)\n",$1,$3}')
    chosen=$(echo -e "${devices}" | dmenu -i -l 10 -p "Which devices?" | cut -d' ' -f1)

    # ---------- Step 2 ----------
    #
    # Mount it to the default mount point. Ask to confirm.
    confirm=$(echo -e "Yes\nNo" | dmenu -i -p "Will mount ${chosen} to ${DEFAULT_MOUNTPOINT}?")
    if [ "${confirm}" = "Yes" ]; then
        sudo mount ${chosen} ${DEFAULT_MOUNTPOINT}
    fi
}

if [ ! -d "${DEFAULT_MOUNTPOINT}" ]; then
    i3-nagbar -t warning -m "Please ensure mount point ${DEFAULT_MOUNTPOINT} exist."
    exit
fi

umount
mount
