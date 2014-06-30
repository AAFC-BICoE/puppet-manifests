#Class to configure a node to act as a swift storage node

class swift::storage {
        #Set ip address in account-server.conf file
        file_line { 'ipconfig-account:':
                path=>"/opt/biocloud/docker/storage/account-server.conf",
                line=>"bind_ip = ${ipaddress_eth0}",
                match=>".*bind_ip.*",
                before=>Exec['run-container'],
        }

        #Set ip address in container-server.conf file
        file_line { 'ipconfig-container:':
                path=>"/opt/biocloud/docker/storage/container-server.conf",
                line=>"bind_ip = ${ipaddress_eth0}",
                match=>".*bind_ip.*",
                before=>Exec['run-container'],
        }

        #Set ip address in object-server.conf file
        file_line { 'ipconfig-object:':
                path=>"/opt/biocloud/docker/storage/object-server.conf",
                line=>"bind_ip = ${ipaddress_eth0}",
                match=>".*bind_ip.*",
                before=>Exec['run-container'],
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
                command=>'/opt/biocloud/docker/storage/containerup',
        }
}
