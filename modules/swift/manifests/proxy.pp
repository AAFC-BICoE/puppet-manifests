#Class to configure a node to act as a swift proxy server
class swift::proxy {
        #Set ip address in proxy file
        file_line { 'ipconfig:':
                path=>"/opt/biocloud/docker/proxy/proxy-server.conf",
                line=>"bind_ip = ${ipaddress_eth0}",
                match=>".*bind_ip.*",
		before=>Exec['run-container'],
        }

        #Ensure memcached is installed--needs to be installed on host OS for docker to work properly with swift
        package { 'memcached':
                ensure=>latest,
		before=>Exec['run-container'],
        }

        #Ensure swift configuration utilities are installed--needed for ring building
        package { 'swift':
                ensure=>latest,
		before=>Exec['run-container'],
        }

        #Spin up the container
        exec { 'run-container':
                command=>'/opt/biocloud/docker/proxy/containerup',
        }
}

