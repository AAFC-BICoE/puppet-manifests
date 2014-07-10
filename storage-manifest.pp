include docker::setup
include swift::storage
Class['docker::setup'] -> Class['swift::storage']
