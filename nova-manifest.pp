#Puppet manifest for setting up a compute node

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

#Creating main nova configuration file
#for now, just copies local configuration file
#Will be replaced by a more robust manifest in a later version
exec { 'nova-config':
        command=>'cp nova.conf /etc/nova/nova.conf',
}
