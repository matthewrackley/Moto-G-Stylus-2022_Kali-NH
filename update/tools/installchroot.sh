#!/sbin/sh
# Install Kali chroot

tmp=$(readlink -f "$0")
tmp=${tmp%/*/*}
. "$tmp/env.sh"

zip=$1

console=$(cat /tmp/console)
[ "$console" ] || console=/proc/$$/fd/1

print() {
	echo "ui_print - $1" > $console
	echo
}

NHSYS=/data/local/nhsystem
get_bb() {
    cd $tmp/tools
    BB_latest=`(ls -v busybox_nh-* 2>/dev/null || ls busybox_nh-*) | tail -n 1`
    BB=$tmp/tools/$BB_latest #Use NetHunter Busybox from tools
    chmod 755 $BB #make busybox executable
    echo $BB
    cd - >/dev/null
}

BB=$(get_bb)

# Get Best Possible ARCH 
ARCH=`cat /system/build.prop  | $BB dos2unix | $BB sed -n "s/^ro.product.cpu.abi=//p" 2>/dev/null | head -n 1`


case $ARCH in 
    arm64*) NH_ARCH=arm64 ;;
    arm*) NH_ARCH=armhf ;;
    armeabi-v7a) NH_ARCH=armhf ;;
    x86_64) NH_ARCH=amd64 ;;
    x86*) NH_ARCH=i386 ;;
    *) print "Unkown architecture Detected. Aborting Chroot Installation..." && exit 1 ;;
esac


verify_fs() {
	# valid architecture?
	case $FS_ARCH in
		armhf|arm64|i386|amd64) ;;
		*) return 1 ;;
	esac
	# valid build size?
	case $FS_SIZE in
		full|minimal|nano) ;;
		*) return 1 ;;
	esac
	return 0
}

# do_install [optional zip containing kalifs]
do_install() {
	print "Found Kali chroot to be installed: $KALIFS"

	mkdir -p "$NHSYS"

	# HACK 1/2: Rename to kali-(arm64,armhf,amd64,i386) as NetHunter App supports searching these directory after first boot
	
	CHROOT="$NHSYS/kali-$NH_ARCH" # Legacy rootfs directory prior to 2020.1
	ROOTFS="$NHSYS/kalifs"  # New symlink allowing to swap chroots via nethunter app on the fly
	PRECHROOT=$($BB find /data/local/nhsystem -type d -name  "*-*" | head -n 1)  #Generic previous chroot location

	# Remove previous chroot
	[ -d "$PRECHROOT" ] && {
		print "Previous Chroot Detected!!Removing..."
		rm -rf "$PRECHROOT"
		rm -f "$ROOTFS"
	}

	# Extract new chroot
	print "Extracting Kali rootfs, this may take up to 25 minutes..."
	if [ "$1" ]; then
		unzip -p "$1" "$KALIFS" | $BB tar -xJf - -C "$NHSYS" --exclude "kali-$FS_ARCH/dev"
	else
	    $BB tar -xJf "$KALIFS" -C "$NHSYS" --exclude "kali-$FS_ARCH/dev"
	fi

	[ $? = 0 ] || {
		print "Error: Kali $FS_ARCH $FS_SIZE chroot failed to install!"
		print "Maybe you ran out of space on your data partition?"
		exit 1
	}

# HACK 2/2: Rename to kali-(arm64,armhf,amd64,i386) based on $NH_ARCH for legacy reasons and create a link to be used by apps effective 2020.1

	mv "$NHSYS/kali-$FS_ARCH" "$CHROOT"
        ln -sf "$CHROOT" "$ROOTFS"

	mkdir -m 0755 "$CHROOT/dev"
	print "Kali $FS_ARCH $FS_SIZE chroot installed successfully!"

	# We should remove the rootfs archive to free up device memory or storage space (if not zip install)
	[ "$1" ] || rm -f "$KALIFS"

	exit 0
}

# Check zip for kalifs-* first
[ -f "$zip" ] && {
	KALIFS=$(unzip -lqq "$zip" | awk '$4 ~ /^kalifs-/ { print $4; exit }')
	# Check other locations if zip didn't contain a kalifs-*
	[ "$KALIFS" ] || return

	FS_ARCH=$(echo "$KALIFS" | awk -F[-.] '{print $2}')
	FS_SIZE=$(echo "$KALIFS" | awk -F[-.] '{print $3}')
	verify_fs && do_install "$zip"
}

# Check these locations in priority order
for fsdir in "$tmp" "/data/local" "/sdcard" "/external_sd"; do

	# Check location for kalifs-[arch]-[size].tar.xz name format
	for KALIFS in "$fsdir"/kalifs-*-*.tar.xz; do
		[ -s "$KALIFS" ] || continue
		FS_ARCH=$(basename "$KALIFS" | awk -F[-.] '{print $2}')
		FS_SIZE=$(basename "$KALIFS" | awk -F[-.] '{print $3}')
		verify_fs && do_install
	done

	# Check location for kalifs-[size].tar.xz name format
	for KALIFS in "$fsdir"/kalifs-*.tar.xz; do
		[ -f "$KALIFS" ] || continue
		FS_ARCH=armhf
		FS_SIZE=$(basename "$KALIFS" | awk -F[-.] '{print $2}')
		verify_fs && do_install
	done

done

print "No Kali rootfs archive found. Skipping..."
exit 0
