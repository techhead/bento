#!/bin/sh -eux

cd /tmp

# https://docs.cloudlinux.com/index.html?converting_existing_servers.html
#wget https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy
#ERROR: certificate common name “download.cloudlinux.com” doesn’t match requested host name “repo.cloudlinux.com”.
wget https://download.cloudlinux.com/cloudlinux/sources/cln/cldeploy

# This is a hack in order to allow kernel/version selection.
# If you know a better way, please fix this.
yum -y install patch
patch -p0 <<'PATCH'
--- cldeploy
+++ cldeploy
@@ -1102,12 +1102,6 @@
 check_root
 yum clean all 2>&1 | tee -a $log
 
-if rpm -qf --queryformat "%{name}" /lib/modules/$(uname -r) > /dev/null 2>&1 ; then
-    KERNEL=$(rpm -qf --queryformat "%{name}" /lib/modules/$(uname -r))
-else
-    KERNEL=kernel
-fi
-
 if [ "$OS_VERSION" -eq "5" ] && [ "$LINODE" = "true" ]; then
     KERNEL=kernel-xen
 fi
PATCH

if [[ -z $KERNEL_VER ]]; then
    KERNEL=$KERNEL_PKG
    KERNEL_DEVEL="$KERNEL_PKG-devel"
else
    KERNEL="$KERNEL_PKG-$KERNEL_VER"
    KERNEL_DEVEL="$KERNEL_PKG-devel-$KERNEL_VER"
fi
export KERNEL

sh cldeploy --skip-version-check -k "$CLOUDLINUX_KEY"
yum -y install $KERNEL_DEVEL

reboot;
sleep 60;
