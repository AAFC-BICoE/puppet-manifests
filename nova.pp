#Puppet manifest for setting up a compute controller node
#Additional compute nodes require less configuration - I'll make a seperate puppet manifest for a compute-only node soon

#Installs nova software & dependencies

include nova::conf_file
include nova::packages

#Kernel change required for Nova to run properly
exec { 'kernel-fix'
	command=>'dpkg-statoverride --update --add root root 0644 /boot/vmlinuz-$(uname -r)',
}

#Adding file to ensure kernal change is persistent
file { '/etc/kernel/postinst.d/statoverride':
        ensure=>present,
        content=>"#!/bin/sh\nversion=\"\$1\"\n# passing the kernel version is required\n[ -z \"\${version}\" ] && exit 0\ndpkg-statoverride --update --add root root 0644 /boot/vmlinuz-\${version}",
}

#Creating dnsmasq-nova configuration file
file { '/etc/nova/dnsmasq-nova.conf':
        ensure=>present,
        content=>"cache-size=0",
}

Class['nova::packages'] -> Class['nova::conf_file']
