#Spin this up BEFORE spinning up Swift

include docker::setup

#Configure proxy server to use keystone
file_line { 'ipconfig1:':
	path=>"/opt/biocloud/docker/proxy/proxy-server.conf",
	line=>"service_host = ${ipaddress_eth0}",
	match=>".*service_host.*",
	before=>Exec['run-container'],
}

file_line { 'ipconfig2:':
        path=>"/opt/biocloud/docker/proxy/proxy-server.conf",
        line=>"auth_host = ${ipaddress_eth0}",
        match=>".*auth_host.*",
        before=>Exec['run-container'],
}

#Spin up the container
exec { 'run-container':
        command=>'/opt/biocloud/docker/keystone/containerup',
        before=>Exec['attach-container']
}

Class['docker::setup'] -> Exec['run-container']
