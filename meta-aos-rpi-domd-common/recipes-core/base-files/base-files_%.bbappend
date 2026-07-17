do_install:append:aos-main-node() {
    # add data partition
    echo '/dev/aosvg/data /var/aos/data ext4 defaults,auto,nofail,noatime,'\
'x-systemd.device-timeout=${aos_disks_timeout}'\
${@bb.utils.contains('DISTRO_FEATURES', 'selinux', ',context=system_u:object_r:aos_var_run_t:s0', '', d)} '0 0' \
   >> ${D}/${sysconfdir}/fstab
}
