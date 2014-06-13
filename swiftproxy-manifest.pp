#Manifest to configure a node to act as a swift proxy server
#These are things that have to be done on the host node BEFORE the swift controller Docker container can be started up!

#Set ip address in proxy file
file_line { 'ipconfig:':
	path=>"/opt/biocloud/proxy/proxy-server.conf",
	line=>"bind_ip = ${ipaddress_eth0}",
	match=>".*bind_ip.*",
}

#Ensure memcached is installed--needs to be installed on host OS for docker to work properly with swift
package { 'memcached':
	ensure=>latest,
}
