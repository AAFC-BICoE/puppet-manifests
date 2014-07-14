include docker::setup

#Spin up the container
exec { 'run-container':
        command=>'/opt/biocloud/docker/horizon/containerup',
        before=>Exec['attach-container']
}

Class['docker::setup'] -> Exec['run-container']
