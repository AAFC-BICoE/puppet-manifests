puppet-manifests
================

Repository housing puppet manifests developped by MBB at AAFC.

Note: Swift & docker manifests are stored in modules.

Note: For the puppet modules to work correctly, modify the /etc/puppet/puppet.conf file so it contains the line "modulepath = /etc/puppet/modules:LOCATION" where LOCATION is the modules/ directory.

Note: For the puppet modules that use Docker containers to work correctly, both the Puppet & Dockerfile repos must BOTH be pulled into the /opt/biocloud/ directory.
