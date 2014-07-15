#Note - For this manifest to work correctly, the Docker repo must be available locally, and the Docker & Puppet root directories must be in the /opt/biocloud/ directory

include docker::setup
include swift::storage
Class['docker::setup'] -> Class['swift::storage']
