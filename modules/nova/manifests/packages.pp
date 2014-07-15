class nova::packages {
	package { 'rabbitmq-server':
	        ensure=>latest,
	        before=>Package['memcached'],
	}
	
	package { 'memcached':
	        ensure=>latest,
	        before=>Package['python-memcache'],
	}
	
	package { 'python-memcache':
	        ensure=>latest,
	        before=>Package['python-novaclient'],
	}
	
	package { 'python-novaclient':
	        ensure=>latest,
	        before=>Package['nova-api'],
	}
	
	package { 'nova-api':
	        ensure=>latest,
	        before=>Package['nova-cert'],
	}
	
	package { 'nova-cert':
	        ensure=>latest,
	        before=>Package['nova-conductor'],
	}
	
	package { 'nova-conductor':
	        ensure=>latest,
	        before=>Package['nova-consoleauth'],
	}
	
	package { 'nova-consoleauth':
	        ensure=>latest,
	        before=>Package['python-novncproxy'],
	}
	
	package { 'nova-novncproxy':
	        ensure=>latest,
	        before=>Package['nova-scheduler'],
	}
	
	package { 'nova-scheduler':
	        ensure=>latest,
	        before=>Package['nova-network'],
	}
	
	package { 'nova-network':
	        ensure=>latest,
	        before=>Package['nova-compute-kvm'],
	}
	
	package { 'nova-compute-kvm':
	        ensure=>latest,
	        before=>Package['python-guestfs'],
	}
	
	package { 'python-guestfs':
	        ensure=>latest,
	}
}
