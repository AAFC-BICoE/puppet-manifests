#Class to configure a node to act as a swift proxy server
class swift::proxy {

	#Create proxy-server.conf
        file { '/opt/biocloud/docker/swift/proxy/proxy-server.conf':
                ensure=>present,
                content=>"[DEFAULT]\nbind_ip = ${ipaddress_eth0}\nbind_port = 8080\nswift_dir = /etc/swift\n\n[pipeline:main]\npipeline = catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk tempurl slo dlo ratelimit authtoken keystoneauth container-quotas account-quotas proxy-logging proxy-server\n\n[app:proxy-server]\nuse = egg:swift#proxy\nallow_account_management = true\naccount_autocreate = true\n\n[filter:authtoken]\npaste.filter_factory=keystoneclient.middleware.auth_token:filter_factory\nauth_protocol = http\nauth_host = ${ipaddress_eth0}\nauth_port = 35357\nauth_token = admin\nservice_protocol = http\nservice_host = ${ipaddress_eth0}\nservice_port = 5000\nadmin_token = admin\nadmin_tenant_name = service\nadmin_user = swift\nadmin_password = swift\ndelay_auth_decision = 0\n\n[filter:keystoneauth]\nuse = egg:swift#keystoneauth\noperator_roles = admin\n\n[filter:healthcheck]\nuse = egg:swift#healthcheck\n\n[filter:cache]\nuse = egg:swift#memcache\n\n[filter:ratelimit]\nuse = egg:swift#ratelimit\n\n[filter:domain_remap]\nuse = egg:swift#domain_remap\n\n[filter:catch_errors]\nuse = egg:swift#catch_errors\n\n[filter:cname_lookup]\nuse = egg:swift#cname_lookup\n\n[filter:tempurl]\nuse = egg:swift#tempurl\n\n[filter:formpost]\nuse = egg:swift#formpost\n\n[filter:name_check]\nuse = egg:swift#name_check\n\n[filter:list-endpoints]\nuse = egg:swift#list_endpoints\n\n[filter:proxy-logging]\nuse = egg:swift#proxy_logging\n\n[filter:bulk]\nuse = egg:swift#bulk\n\n[filter:container-quotas]\nuse = egg:swift#container_quotas\n\n[filter:slo]\nuse = egg:swift#slo\n\n[filter:dlo]\nuse = egg:swift#dlo\n\n[filter:account-quotas]\nuse = egg:swift#account_quotas\n\n[filter:gatekeeper]\nuse = egg:swift#gatekeeper\n\n[filter:container_sync]\nuse = egg:swift#container_sync\n",
        }

	#Create swift.conf
        file { '/opt/biocloud/docker/swift/proxy/swift.conf':
                ensure=>present,
                content=>"[swift-hash]\nswift_hash_path_suffix = sn2yf1qbs4\nswift_hash_path_prefix = changeme\n",
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
                command=>'/opt/biocloud/docker/swift/proxy/containerup',
        }
}
