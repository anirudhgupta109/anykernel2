# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=IllusionKernel by anirudhgupta109
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=OnePlus6T
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

## begin vendor changes
mount -o rw,remount -t auto /system >/dev/null;

# Make a backup
restore_file /system/etc/init/init.target.rc;

# Do work
replace_string /system/etc/init/init.target.rc "write /dev/stune/top-app/schedtune.colocate 0" "write /dev/stune/top-app/schedtune.colocate 1" "write /dev/stune/top-app/schedtune.colocate 0";
replace_string /system/etc/init/init.target.rc "write /dev/stune/foreground/schedtune.sched_boost_no_override 0" "write /dev/stune/foreground/schedtune.sched_boost_no_override 1" "write /dev/stune/foreground/schedtune.sched_boost_no_override 0";
replace_string /system/etc/init/init.target.rc "write /dev/stune/top-app/schedtune.sched_boost_no_override 0" "write /dev/stune/top-app/schedtune.sched_boost_no_override 1" "write /dev/stune/top-app/schedtune.sched_boost_no_override 0";

# Cleanup previous performance additions
remove_section /system/etc/init/init.target.rc "##START_RZ" "##END_RZ";

# Add performance tweaks
append_file /system/etc/init/init.target.rc "R4ND0MSTR1NG" init.target.rc ;

## AnyKernel install
dump_boot;

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
  ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;

# Install the boot image
write_boot;
