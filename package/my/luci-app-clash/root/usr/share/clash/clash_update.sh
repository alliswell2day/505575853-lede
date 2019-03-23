#!/bin/sh
logfile="/var/log/clash.file"
dir="/usr/share/clash/"
clash_new_version=$(wget -qO- "https://github.com/Dreamacro/clash/tags"| grep "/Dreamacro/clash/releases/tag/"| head -n 1| awk -F "/tag/v" '{print $2}'| sed 's/\">//')
echo "$clash_new_version" > ${dir}clash_new_version
if [ $? -eq 0 ];then
	clash_new_version=$(cat ${dir}clash_new_version|sed -n '1p')
	echo "$(date "+%Y-%m-%d %H:%M:%S") clash自动更新启动，验证版本..." >> ${logfile}
	
	if ( ! cmp -s ${dir}clash_version ${dir}clash_new_version );then
		echo "$(date "+%Y-%m-%d %H:%M:%S") 检测到clash最新版本为$clash_new_version..." >> ${logfile}

		UpdateApp() {
			for a in $(opkg print-architecture | awk '{print $2}'); do
				case "$a" in
					all|noarch)
						;;
					aarch64_armv8-a|arm_arm1176jzf-s_vfp|arm_arm926ej-s|arm_cortex-a15_neon-vfpv4|arm_cortex-a5|arm_cortex-a53_neon-vfpv4|arm_cortex-a7_neon-vfpv4|arm_cortex-a8_vfpv3|arm_cortex-a9|arm_cortex-a9_neon|arm_cortex-a9_vfpv3|arm_fa526|arm_mpcore|arm_mpcore_vfp|arm_xscale|armeb_xscale)
						ARCH="armv6"
						;;
					i386_pentium|i386_pentium4)
						ARCH="386"
						;;
					ar71xx|mips_24kc|mips_mips32|mips64_octeon)
						ARCH="mips64"
						;;
					mipsel_24kc|mipsel_24kec_dsp|mipsel_74kc|mipsel_mips32|mipsel_1004kc_dsp)
						ARCH="mipsle"
						;;
					x86_64)
						ARCH="amd64"
						;;
					*)
						exit 0
						;;
				esac
			done
		}

		download_binary(){
			echo "$(date "+%Y-%m-%d %H:%M:%S") 开始下载clash二进制文件..." >> ${logfile}
			bin_dir="/tmp"
			UpdateApp
			cd $bin_dir
			down_url=https://github.com/Dreamacro/clash/releases/download/v"$clash_new_version"/clash-linux-"$ARCH".gz

			local a=0
			while [ ! -f $bin_dir/clash-linux-"$ARCH"*.gz ]; do
				[ $a = 6 ] && exit
				/usr/bin/wget -T10 $down_url
				sleep 2
				let "a = a + 1"
			done

			kill -9 $(ps | grep clash-watchdog.sh | grep -v grep | awk '{print $1}') >/dev/null 2>&1
			kill $(pidof clash) >/dev/null 2>&1 || kill -9 $(ps | grep clash | grep -v grep | awk '{print $1}') >/dev/null 2>&1
	
			gunzip -d clash-linux-"$ARCH"*.gz
			mv $bin_dir/clash-linux-"$ARCH" /usr/bin/clash
			rm -rf $bin_dir/clash-linux-"$ARCH"*.gz
			rm -rf $bin_dir/clash-linux-"$ARCH"
			if [ -f "/usr/bin/clash" ]; then
				chmod +x /usr/bin/clash && echo "$(date "+%Y-%m-%d %H:%M:%S") 成功下载clash二进制文件" >> ${logfile}
				/etc/init.d/clash restart
			else
				echo "$(date "+%Y-%m-%d %H:%M:%S") 下载clash二进制文件失败，请重试！" >> ${logfile}
			fi
		}

		download_binary
		echo "" > ${dir}clash_version
		echo "$clash_new_version" > ${dir}clash_version
		rm -rf ${dir}clash_new_version
	else
		echo "$(date "+%Y-%m-%d %H:%M:%S") clash已经是最新的了..." >> ${logfile}
		rm -rf ${dir}clash_new_version
	fi
fi
