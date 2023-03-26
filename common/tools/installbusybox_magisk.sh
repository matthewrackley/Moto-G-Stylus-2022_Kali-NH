#!/sbin/sh
# Install NetHunter's busybox
# Must be called from the NetHunter magisk module script

print_ui > /dev/null 2>&1 || {
    print_ui() {
        echo $1;
    }
}

ls $TMP/tools/busybox_nh-* 1> /dev/null 2>&1 || {
    print_ui "No NetHunter Busybox found - skipping.";
    exit 1;
}

[ -z $BIN ] && {
    BIN=$TARGET/bin;
}

[ -z $XBIN ] && {
   if [ -d /system/xbin ]; then
       XBIN=$TARGET/xbin;
   else
       XBIN=$TARGET/bin;
   fi
}

[ -d $XBIN ] || mkdir -p $XBIN;

ui_print "Installing NetHunter BusyBox...";
cd $TMP/tools;
bb_list=$(ls busybox_nh-*);
for bb in $bb_list; do
    ui_print "Installing $bb...";
    rm -f $XBIN/$bb 2>/dev/null;
    cp -f $bb $XBIN/$bb;
    chmod 0755 $XBIN/$bb;
done

cd $XBIN;
busybox_latest=`(ls -v busybox_nh-* ) | tail -n 1`;
ui_print "Setting $busybox_latest as default";
$XBIN/$busybox_latest ln -sf $busybox_latest busybox_nh

# Create symlink for applets
ui_print "Creating symlinks for busybox applets";
sysbin="$(ls /system/bin)";
existbin="$(ls $BIN 2>/dev/null)";
for applet in $($XBIN/busybox_nh --list); do
    case $XBIN in
        */bin)
            if [ "$(echo "$sysbin" | $XBIN/busybox_nh grep "^$applet$")" ]; then
                if [ "$(echo "$existbin" | $XBIN/busybox_nh grep "^$applet$")" ]; then
                    $XBIN/busybox_nh ln -sf busybox_nh $applet;
                fi;
            else
                $XBIN/busybox_nh ln -sf busybox_nh $applet;
            fi;
        ;;
        *) $XBIN/busybox_nh ln -sf busybox_nh $applet;
    esac;
done;

[ -e $XBIN/busybox ] || {
    ui_print "${XBIN}/busybox not found! Symlinking...";
    $XBIN/$busybox_latest ln -sf busybox_nh busybox;
}
set_perm_recursive "$XBIN" 0 0 0755 0755;
cd -
