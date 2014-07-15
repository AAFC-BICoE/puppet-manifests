#Note - For this manifest to work correctly, the Docker repo must be available locally, and the Docker & Puppet root directories must be in the /opt/biocloud/ directory

include docker::setup

#spin up the container
exec { 'run-container':
	command=>'/opt/biocloud/docker/irods/icat/containerup',
}

Class['docker::setup'] -> Exec['run-container']
