#Puppet manifest for setting up a compute controller node
#Additional compute nodes require less configuration - I'll make a seperate puppet manifest for a compute-only node soon

#Installs nova software & dependencies
package { 'rabbitmq-server':
	ensure=>latest,
	before=>Package['memcached'],
}

package { 'memcached':
        ensure=>latest,
	before=>Package['python-memcache'],
}

package { 'python-memcache':
        ensure=>latest,
	before=>Package['python-novaclient'],
}

package { 'python-novaclient':
        ensure=>latest,
	before=>Package['nova-api'],
}

package { 'nova-api':
        ensure=>latest,
	before=>Package['nova-cert'],
}

package { 'nova-cert':
        ensure=>latest,
	before=>Package['nova-conductor'],
}

package { 'nova-conductor':
        ensure=>latest,
	before=>Package['nova-consoleauth'],
}

package { 'nova-consoleauth':
        ensure=>latest,
	before=>Package['python-novncproxy'],
}

package { 'nova-novncproxy':
        ensure=>latest,
	before=>Package['nova-scheduler'],
}

package { 'nova-scheduler':
        ensure=>latest,
	before=>Package['nova-network'],
}

package { 'nova-network':
        ensure=>latest,
	before=>Package['nova-compute-kvm'],
}

package { 'nova-compute-kvm':
        ensure=>latest,
	before=>Package['python-guestfs'],
}

package { 'python-guestfs':
        ensure=>latest,
}

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

#Creating main nova configuration file; sourced from local file
exec { 'nova-config':
        command=>'cp nova.conf /etc/nova/nova.conf',
}

#Set node IP address in places where its required
file_line { 'rabbit-host-config:':
	path=>"/etc/nova/nova.conf",
	line=>"rabbit_host=${ipaddress_eth0}",
	match=>".*rabbit_host.*",
	require=>Exec['nova-config'],
}

file_line { 'my-ip-config:':
	path=>"/etc/nova/nova.conf",
	line=>"my_ip=${ipaddress_eth0}",
	match=>".*my_ip=.*",
	require=>Exec['nova-config'],
}

file_line { 'novncproxy-config:':
	path=>"/etc/nova/nova.conf",
	line=>"novncproxy_host=${ipaddress_eth0}",
	match=>".*novncproxy_host.*",
	require=>Exec['nova-config'],
}

file_line { 'vncserver-listen-config:':
	path=>"/etc/nova/nova.conf",
	line=>"vncserver_listen=${ipaddress_eth0}",
	match=>".*vncserver_listen.*",
	require=>Exec['nova-config'],
}

file_line { 'vncserver-proxyclient-config:':
	path=>"/etc/nova/nova.conf",
	line=>"vncserver_proxyclient_address=${ipaddress_eth0}",
	match=>".*vncserver_proxyclient_address.*",
	require=>Exec['nova-config'],
}

file_line { 'osapi-config:':
	path=>"/etc/nova/nova.conf",
	line=>"osapi_compute_listen=${ipaddress_eth0}",
	match=>".*osapi_compute_listen.*",
	require=>Exec['nova-config'],
}

file_line { 'ec2-listen-config:':
	path=>"/etc/nova/nova.conf",
	line=>"ec2_listen=${ipaddress_eth0}",
	match=>".*ec2_listen.*",
	require=>Exec['nova-config'],
}

file_line { 'ec2-host:':
	path=>"/etc/nova/nova.conf",
	line=>"ec2_host=${ipaddress_eth0}",
	match=>".*ec2_host.*",
	require=>Exec['nova-config'],
}
