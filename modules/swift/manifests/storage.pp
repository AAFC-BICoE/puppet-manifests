#Class to configure a node to act as a swift storage node

class swift::storage {
	
	#Create rsyncd.conf
	file { '/opt/biocloud/docker/swift/storage/rsyncd.conf':
	        ensure=>present,
	        content=>"uid = swift\ngid = swift\nlog file = /var/log/rsyncd.log\npid file = /var/run/rsyncd.pid\n\n[account]\nmax connections = 2\npath = /srv/node/\nread only = false\nlock file = /var/lock/account.lock\n\n[container]\nmax connections = 2\npath = /srv/node/\nread only = false\nlock file = /var/lock/container.lock\n\n[object]\nmax connections = 2\npath = /srv/node/\nread only = false\nlock file = /var/lock/object.lock",
	}

	#Create account-server.conf
	file { '/opt/biocloud/docker/swift/storage/account-server.conf':
	        ensure=>present,
	        content=>"[DEFAULT]\nbind_ip = ${ipaddress_eth0}\nbind_port = 6002\n\n[pipeline:main]\npipeline = healthcheck recon account-server\n\n[app:account-server]\nuse = egg:swift#account\n\n[filter:healthcheck]\nuse = egg:swift#healthcheck\n\n[filter:recon]\nuse = egg:swift#recon",
	}

	#Create container-server.conf
	file { '/opt/biocloud/docker/swift/storage/container-server.conf':
	        ensure=>present,
	        content=>"[DEFAULT]\nbind_ip = ${ipaddress_eth0}\nbind_port = 6001\n\n[pipeline:main]\npipeline = healthcheck recon container-server\n\n[app:container-server]\nuse = egg:swift#container\n\n[filter:healthcheck]\nuse = egg:swift#healthcheck\n\n[filter:recon]\nuse = egg:swift#recon",
	}

	#Create object-server.conf
	file { '/opt/biocloud/docker/swift/storage/object-server.conf':
	        ensure=>present,
        	content=>"[DEFAULT]\nbind_ip = ${ipaddress_eth0}\nbind_port = 6000\n\n[pipeline:main]\npipeline = healthcheck recon object-server\n\n[app:object-server]\nuse = egg:swift#object\n\n[filter:healthcheck]\nuse = egg:swift#healthcheck\n\n[filter:recon]\nuse = egg:swift#recon",
	}

	#Create swift.conf
        file { '/opt/biocloud/docker/swift/proxy/swift.conf':
                ensure=>present,
                content=>"[swift-hash]\nswift_hash_path_suffix = sn2yf1qbs4\nswift_hash_path_prefix = changeme\n",
        }

        #Ensure memcached is installed--needs to be installed on host OS for docker to work properly with swift
        package { 'memcached':
                ensure=>latest,
                before=>Exec['run-container'],
        }

        #Ensure xfsprogs is installed--needs to be installed on host OS to mount disks
        package { 'xfsprogs':
                ensure=>latest,
                before=>Exec['format-disks'],
        }

        #Ensure /srv exists (for /srv/node)
        file { 'ensure-srv-directory':
                path=>'/srv',
                ensure=>directory,
                before=>File['ensure-node-directory'],
        }

        #Ensure /srv/node exists
        file { 'ensure-node-directory':
                path=>'/srv/node',
                ensure=>directory,
                mode=>0755,
                before=>Exec['mount-disks'],
        }

        #Format disks
        exec { 'format-disks':
                command=>'/opt/biocloud/disk/diskformatting',
                before=>Exec['mount-disks'],
        }

        #Mount disks
        exec { 'mount-disks':
                command=>'/opt/biocloud/disk/diskmounting',
                before=>Exec['run-container'],
        }

        #Spin up container!
        exec { 'run-container':
                command=>'/opt/biocloud/docker/swift/storage/containerup',
        }
}
