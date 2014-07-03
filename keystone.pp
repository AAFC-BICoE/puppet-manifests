include docker::setup

#spin up the container
exec { 'run-container':
	command=>'/opt/biocloud/docker/keystone/containerup',
	before=>Exec['attach-container']
}

Class['docker::setup'] -> Exec['run-container']
