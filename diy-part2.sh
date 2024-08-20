#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Update kernel version to 5.15.162
sed -i 's/LINUX_VERSION-5.4 = .213//g' include/kernel-version.mk
sed -i 's/LINUX_KERNEL_HASH-5.4.213 = e67ce168477e580375a80f3caef16819a85b15faa2d382adc6df18a62ad6baf1//g' include/kernel-version.mk
sed -i 's/LINUX_KERNEL_HASH-5.10.33 = 933fdbc36371c0f830b7a6a957a559fca2dad1cc0eaa852ef42fb168185b4315/LINUX_KERNEL_HASH-5.10.162 = 00444ab103f5e4ce34d3ba7895289d2b78b84f14a35f9021b60cb1a0270dfec5/g' include/kernel-version.mk
sed -i 's/5.15.33/5.15.162/g' package/kernel/mac80211/Makefile
sed -i 's/07237fd9f66ce4b95d551569e2f8395342fdb720305f01aa52cd5ca216594278/00444ab103f5e4ce34d3ba7895289d2b78b84f14a35f9021b60cb1a0270dfec5/g' package/kernel/mac80211/Makefile
sed -i 's/CONFIG_LINUX_5_10=y/CONFIG_LINUX_5_15=y/g' .config
sed -i 's/CPU_SUBTYPE:=neon//g' target/linux/msm89xx/msm8916/target.mk
mv target/linux/msm89xx/patches-5.10 target/linux/msm89xx/patches-5.15
mv target/linux/msm89xx/config-5.10 target/linux/msm89xx/config-5.15

# Clone community packages to package
mkdir -p package/community
pushd package/community

# HelmiWrt packages
git clone --depth=1 https://github.com/Haris131/helmiwrt-packages

git clone --depth=1 https://github.com/gSpotx2f/luci-app-cpu-status
git clone --depth=1 https://github.com/gSpotx2f/luci-app-temp-status

# Out to openwrt dir
popd

#-----------------------------------------------------------------------------
#   Start of @helmiau terminal scripts additionals menu
#-----------------------------------------------------------------------------
HWOSDIR="package/base-files/files"
rawgit="https://raw.githubusercontent.com"
[ ! -d $HWOSDIR/usr/bin ] && mkdir -p $HWOSDIR/usr/bin

# Add ram checker
# run "ram" using terminal to check ram usage
wget --no-check-certificate -qO $HWOSDIR/usr/bin/ram "$rawgit/haris131/speedtest/main/ram.py"
wget --no-check-certificate -qO $HWOSDIR/usr/bin/speedtest "$rawgit/haris131/speedtest/main/speedtest"

# Add mmsms
wget --no-check-certificate -qO $HWOSDIR/usr/bin/mmsms "$rawgit/satriakanda/mmsms/main/mmsms"

# Add fix download file.php for xderm and libernet
# run "fixphp" using terminal for use
wget --no-check-certificate -qO $HWOSDIR/usr/bin/fixphp "$rawgit/helmiau/openwrt-config/main/fix-xderm-libernet-gui"

chmod +x $HWOSDIR/usr/bin/ram $HWOSDIR/usr/bin/mmsms $HWOSDIR/usr/bin/speedtest $HWOSDIR/usr/bin/fixphp
