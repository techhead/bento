#!/bin/sh -eux

hostname $HOST

# https://documentation.cpanel.net/display/ALD/Installation+Guide+-+Customize+Your+Installation
touch /etc/install_legacy_ea3_instead_of_ea4
#echo "CPANEL=68.0.19">/etc/cpupdate.conf
cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
rm -f /home/latest

reboot;
sleep 60;
