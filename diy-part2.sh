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

#移除不用软件包
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/lang/node
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/transmission
rm -rf feeds/packages/net/transmission-web-control
rm -rf feeds/luci/applications/luci-app-transmission
rm -rf feeds/packages/net/lucky
rm -rf feeds/luci/applications/luci-app-lucky


#rm -rf feeds/luci/applications/luci-app-dockerman


#添加额外软件包
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt -b packages-24.10 feeds/packages/lang/node 
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone --depth=1 https://github.com/vernesong/OpenClash.git
cp -rf OpenClash/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
#rm -rf OpenClash
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
#git clone --depth=1 https://github.com/lisaac/luci-app-dockerman.git
#cp -rf luci-app-dockerman/applications/luci-app-dockerman package/luci-app-dockerman
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git lucky-repo
cp -rf lucky-repo/luci-app-lucky package/luci-app-lucky
cp -rf lucky-repo/lucky package/lucky

# 克隆 kenzok8-packages 仓库
git clone --depth=1 https://github.com/kenzok8/small-package.git kenzok8-packages
cp -rf kenzok8-packages/alist package/alist
cp -rf kenzok8-packages/luci-app-alist package/luci-app-alist
cp -rf kenzok8-packages/luci-app-ikoolproxy package/luci-app-ikoolproxy
#cp -rf kenzok8-packages/luci-app-eqos package/luci-app-eqos
#cp -rf kenzok8-packages/luci-app-openlist package/luci-app-openlist
cp -rf kenzok8-packages/UnblockNeteaseMusic-Go package/UnblockNeteaseMusic-Go
cp -rf kenzok8-packages/UnblockNeteaseMusic package/UnblockNeteaseMusic
cp -rf kenzok8-packages/luci-app-unblockneteasemusic package/luci-app-unblockneteasemusic
#cp -rf kenzok8-packages/luci-app-fileassistant package/luci-app-fileassistant
cp -rf kenzok8-packages/luci-app-transmission package/luci-app-transmission
cp -rf kenzok8-packages/transmission package/transmission
cp -rf kenzok8-packages/transmission-web-control package/transmission-web-control
rm -rf kenzok8-packages

#添加istore
git clone --depth=1 https://github.com/linkease/istore-ui.git
cp -rf istore-ui/app-store-ui package/app-store-ui
cp -rf istore-ui package/store-ui
git clone --depth=1 https://github.com/linkease/istore.git
cp -rf istore/luci/luci-app-store package/luci-app-store
cp -rf istore package/istore
sed -i 's/luci-lib-ipkg/luci-base/g' package/luci-app-store/Makefile
#rm -rf istore-ui istore



# Modify default IP
sed -i 's/192.168.1.1/192.168.216.2/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.1.1/192.168.99.2/g' package/base-files/luci2/bin/config_generate

#readd cpufreq for aarch64
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
#sed -i 's/services/system/g'  package/lean/luci-app-cpufreq/luasrc/controller/cpufreq.lua

./scripts/feeds update -a
./scripts/feeds install -a -f


