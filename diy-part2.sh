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

# Change hash kernel
sed -i 's/07237fd9f66ce4b95d551569e2f8395342fdb720305f01aa52cd5ca216594278/1b6b3bded4c81814ebebe2d194c2f8966d2399005b85ebb0557285b6e73f5422/g' package/kernel/mac80211/Makefile

# Clone community packages to package
mkdir -p package/community
pushd package/community

# HelmiWrt packages
svn co https://github.com/Haris131/helmiwrt-packages/trunk/badvpn badvpn
svn co https://github.com/Haris131/helmiwrt-packages/trunk/corkscrew corkscrew
svn co https://github.com/Haris131/helmiwrt-packages/trunk/dnstt dnstt
svn co https://github.com/Haris131/helmiwrt-packages/trunk/luci-app-libernet-plus luci-app-libernet-plus

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

# Add ram checker from wegare123
# run "ram" using terminal to check ram usage
wget --no-check-certificate -qO $HWOSDIR/bin/ram "$rawgit/wegare123/ram/main/ram.sh"

# Add fix download file.php for xderm and libernet
# run "fixphp" using terminal for use
wget --no-check-certificate -qO $HWOSDIR/bin/fixphp "$rawgit/helmiau/openwrt-config/main/fix-xderm-libernet-gui"
