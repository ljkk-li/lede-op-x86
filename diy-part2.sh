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


#添加额外软件包
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt -b packages-25.12 feeds/packages/lang/node 
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/lean/luci-theme-argon
git clone --depth=1 https://github.com/vernesong/OpenClash.git
cp -rf OpenClash/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
#rm -rf OpenClash

# 克隆 kenzok8-packages 仓库
git clone --depth=1 https://github.com/kenzok8/small-package.git kenzok8-packages
cp -rf kenzok8-packages/alist package/alist
cp -rf kenzok8-packages/luci-app-alist package/luci-app-alist
cp -rf kenzok8-packages/luci-app-ikoolproxy package/luci-app-ikoolproxy
rm -rf kenzok8-packages

# Modify default IP
sed -i 's/192.168.1.1/192.168.99.2/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.1.1/192.168.99.2/g' package/base-files/luci2/bin/config_generate

#readd cpufreq for aarch64
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
#sed -i 's/services/system/g'  package/lean/luci-app-cpufreq/luasrc/controller/cpufreq.lua


