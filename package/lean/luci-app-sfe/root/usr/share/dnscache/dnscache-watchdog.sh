#!/bin/sh

dns_enable=$(uci get sfe.config.dns 2>/dev/null)
hosts=$(uci get sfe.config.hosts 2>/dev/null)
dnscache_enable=$(uci get sfe.config.dnscache_enable 2>/dev/null)

if [ $dns_enable -eq 1 ]; then
	if [ $hosts -eq 1 ]; then
		wget --no-check-certificate -q -O /tmp/hosts01.txt https://hosts.nfz.moe/127.0.0.1/full/hosts
		wget --no-check-certificate -q -O /tmp/hosts02.txt https://raw.githubusercontent.com/vokins/yhosts/master/hosts
		wget --no-check-certificate -q -O /tmp/hosts03.txt http://www.malwaredomainlist.com/hostslist/hosts.txt
		wget --no-check-certificate -q -O /tmp/hosts04.txt https://adaway.org/hosts.txt
		wget --no-check-certificate -q -O /tmp/hosts05.txt http://winhelp2002.mvps.org/hosts.txt
		wget --no-check-certificate -q -O /tmp/hosts06.txt https://hosts-file.net/ad_servers.txt
		wget --no-check-certificate -q -O /tmp/ad01.txt https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf
		wget --no-check-certificate -q -O /tmp/ad02.txt https://c.nnjsx.cn/GL/dnsmasq/update/adblock/easylistchina.txt
		wget --no-check-certificate -q -O /tmp/ad03.txt http://iytc.net/tools/ad.conf
		wget-ssl --no-check-certificate -O- https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' > /tmp/ad04.txt
		sleep 60
		if [ -s "/tmp/hosts01.txt" ];then
			sed -i '1,19d' /tmp/hosts01.txt
			if ( ! cmp -s /tmp/hosts01.txt /etc/hostslist/hosts01 );then
				mv /tmp/hosts01.txt /etc/hostslist/hosts01
				echo "hosts01 copy"
			fi
		fi

		if [ -s "/tmp/hosts02.txt" ];then
			sed -i '1,3d' /tmp/hosts02.txt
			if ( ! cmp -s /tmp/hosts02.txt /etc/hostslist/hosts02 );then
				mv /tmp/hosts02.txt /etc/hostslist/hosts02
				echo "hosts02 copy"
			fi
		fi

		if [ -s "/tmp/hosts03.txt" ];then
			sed -i '1,6d' /tmp/hosts03.txt
				if ( ! cmp -s /tmp/hosts03.txt /etc/hostslist/hosts03 );then
				mv /tmp/hosts03.txt /etc/hostslist/hosts03
				echo "hosts03 copy"
			fi
		fi

		if [ -s "/tmp/hosts04.txt" ];then
			sed -i '1,24d' /tmp/hosts04.txt
			if ( ! cmp -s /tmp/hosts04.txt /etc/hostslist/hosts04 );then
				mv /tmp/hosts04.txt /etc/hostslist/hosts04
				echo "hosts04 copy"
			fi
		fi

		if [ -s "/tmp/hosts05.txt" ];then
			sed -i '1,30d' /tmp/hosts05.txt
			if ( ! cmp -s /tmp/hosts05.txt /etc/hostslist/hosts05 );then
				mv /tmp/hosts05.txt /etc/hostslist/hosts05
				echo "hosts05 copy"
			fi
		fi

		if [ -s "/tmp/hosts06.txt" ];then
			sed -i '1,10d' /tmp/hosts06.txt
			if ( ! cmp -s /tmp/hosts06.txt /etc/hostslist/hosts06 );then
				mv /tmp/hosts06.txt /etc/hostslist/hosts06
				echo "hosts06 copy"
			fi
		fi

		if [ -s "/tmp/ad01.txt" ];then
			sed -i '/hao123/d' /tmp/ad01.txt
			if ( ! cmp -s /tmp/ad01.txt /etc/dnsmasq.ad/ad01.conf );then		
				mv /tmp/ad01.txt /etc/dnsmasq.ad/ad01.conf
				echo "ad01 copy"
			fi
		fi
	
		if [ -s "/tmp/ad02.txt" ];then
			if ( ! cmp -s /tmp/ad02.txt /etc/dnsmasq.ad/ad02.conf );then
				mv /tmp/ad02.txt /etc/dnsmasq.ad/ad02.conf
				echo "ad02 copy"
			fi
		fi

		if [ -s "/tmp/ad03.txt" ];then
			if ( ! cmp -s /tmp/ad03.txt /etc/dnsmasq.ad/ad03.conf );then
				mv /tmp/ad03.txt /etc/dnsmasq.ad/ad03.conf
				echo "ad03 copy"
			fi
		fi
		
		if [ -s "/tmp/ad04.txt" ];then
			if ( ! cmp -s /tmp/ad04.txt /etc/dnsmasq.ad/ad04.conf );then
				mv /tmp/ad04.txt /etc/dnsmasq.ad/ad04.conf
				echo "ad04 copy"
			fi
		fi

	fi
	rm -rf /tmp/hosts01.txt /tmp/hosts02.txt /tmp/hosts03.txt /tmp/hosts04.txt /tmp/hosts05.txt /tmp/hosts06.txt /tmp/ad01.txt /tmp/ad02.txt /tmp/ad03.txt /tmp/ad04.txt
	
	if [ $dnscache_enable = "3" ];  then
		if ! pidof AdGuardHome>/dev/null; then
			/etc/init.d/sfe restart
			echo "restart"
		fi
	
	else
		if ! pidof dnscache>/dev/null; then
			/etc/init.d/sfe restart
			echo "restart"
		fi
	fi
	echo "esc"
fi

