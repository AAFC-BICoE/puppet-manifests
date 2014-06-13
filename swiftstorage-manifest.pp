#Manifest to configure a node to act as a swift storage node
#This manifest must be run on the host node BEFORE the swift storage node Docker container can be started up!

#Set ip address in account-server.conf file
file_line { 'ipconfig-account:':
	path=>"/opt/biocloud/docker/storage/account-server.conf",
	line=>"bind_ip = ${ipaddress_eth0}",
	match=>".*bind_ip.*",
}

#Set ip address in container-server.conf file
file_line { 'ipconfig-container:':
        path=>"/opt/biocloud/docker/storage/container-server.conf",
        line=>"bind_ip = ${ipaddress_eth0}",
        match=>".*bind_ip.*",
}


#Set ip address in object-server.conf file
file_line { 'ipconfig-object:':
        path=>"/opt/biocloud/docker/storage/object-server.conf",
        line=>"bind_ip = ${ipaddress_eth0}",
        match=>".*bind_ip.*",
}

#Ensure memcached is installed--needs to be installed on host OS for docker to work properly with swift
package { 'memcached':
	ensure=>latest,
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
}
