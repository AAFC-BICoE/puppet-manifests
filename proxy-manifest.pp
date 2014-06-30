include docker::setup
include swift::proxy
Class['docker::setup'] -> Class['swift::proxy']
