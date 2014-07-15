class nova::conf_file {
	file { '/opt/biocloud/puppet/t1':
	        ensure=>present,
		content=>"[DEFAULT]\n\n",
		before=>File_Line['logs'],
	}
	
	file_line { 'logs':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#LOGS\nverbose=True\ndebug=False\nlogdir=/var/log/nova\n\n",
		before=>File_Line['state'],
	}
	
	file_line { 'state':
	        path=>'/opt/biocloud/puppet/t1',
	        line=>"#STATE\nauth_strategy=keystone\nstate_path=/var/lib/nova\nlock_path=/run/lock/nova\nrootwrap_config=/etc/nova/rootwrap.conf\n\n",
		before=>File_Line['paste'],
	}
	
	file_line { 'paste':
	        path=>'/opt/biocloud/puppet/t1',
		line=>"#PASTE FILE\napi_paste_config=/etc/nova/api-paste.ini\n\n",
		before=>File_Line['rabbit'],
	}
	
	file_line { 'rabbit':
	        path=>'/opt/biocloud/puppet/t1',
	        line=>"#RABBIT\nrabbit_host=${ipaddress_eth0}\nrabbit_port=5672\nrpc_backend = nova.openstack.common.rpc.impl_kombu\nrabbit_userid=guest\nrabbit_password=guest\n\n",
		before=>File_Line['scheduler'],
	}
	
	file_line { 'scheduler':
	        path=>'/opt/biocloud/puppet/t1',
	        line=>"#SCHEDULER\ncompute_scheduler_driver=nova.scheduler.filter_scheduler.FilterScheduler\n\n",
		before=>File_Line['network'],
	}
	
	file_line { 'network':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#NETWORK\nnetwork_manager=nova.network.manager.FlatDHCPManager\nforce_dhcp_release=True\ndhcpbridge_flagfile=/etc/nova/nova.conf\ndhcpbridge=/usr/bin/nova-dhcpbridge\nfirewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver\nmy_ip=${ipaddress_eth0}\npublic_interface=eth0\nvlan_interface=eth0\nflat_network_bridge=br100\nflat_interface=eth0\ndnsmasq_config_file=/etc/nova/dnsmasq-nova.conf\nfixed_range=''\nenable_ipv6=False\n\n",
		before=>File_Line['glance'],
	}
	
	file_line { 'glance':
	        path=>'/opt/biocloud/puppet/t1',
	        line=>"#GLANCE\nimage_service=nova.image.glance.GlanceImageService\nglance_api_servers=${ipaddress_eth0}:9292\nglance_host=${ipaddress_eth0}\n\n",
		before=>File_Line['compute'],
	}
	
	file_line { 'compute':
	        path=>'/opt/biocloud/puppet/t1',
		line=>"#COMPUTE\nnetwork_api_class = nova.network.api.API\nsecurity_group_api = nova\ncompute_manager=nova.compute.manager.ComputeManager\nconnection_type=libvirt\ncompute_driver=libvirt.LibvirtDriver\nlibvirt_type=kvm\nlibvirt_inject_key=false\nroot_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf\nremove_unused_base_images=true\nremove_unused_resized_minimum_age_seconds=3600\nremove_unused_original_minimum_age_seconds=3600\nchecksum_base_images=false\nstart_guests_on_host_boot=true\nresume_guests_state_on_host_boot=true\nvolumes_path=/var/lib/nova/volumes\n\n",
		before=>File_Line['quotas'],
	}
	
	file_line { 'quotas':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#QUOTAS\nquota_security_groups=50\nquota_fixed_ips=40\nquota_instances=20\nforce_config_drive=false\ncpu_allocation_ratio=16.0\nram_allocation_ratio=1.5\n\n",
		before=>File_Line['vnc_config'],
	}
	
	file_line { 'vnc_config':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#VNC_CONFIG\nmy_ip=${ipaddress_eth0}\nnovnc_enabled=true\nnovncproxy_base_url=http://${ipaddress_eth0}:6080/vnc_auto.html\nxvpvncproxy_base_url=http://${ipaddress_eth0}:6081/console\nnovncproxy_host=${ipaddress_eth0}\nnovncproxy_port=6080\nvncserver_listen=${ipaddress_eth0}\nvncserver_proxyclient_address=${ipaddress_eth0}\n\n",
		before=>File_Line['other'],
	}
	
	file_line { 'other':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#OTHERS\nosapi_max_limit=1000\n\n",
		before=>File_Line['apis'],
	}
	
	file_line { 'apis':
		path=>'/opt/biocloud/puppet/t1',
		line=>"#APIs\nenabled_apis=ec2,osapi_compute,metadata\nosapi_compute_extension = nova.api.openstack.compute.contrib.standard_extensions\nec2_workers=4\nosapi_compute_workers=4\nmetadata_workers=4\nosapi_volume_workers=4\nosapi_compute_listen=${ipaddress_eth0}\nosapi_compute_listen_port=8774\nec2_listen=${ipaddress_eth0}\nec2_listen_port=8773\nec2_host=${ipaddress_eth0}\nec2_private_dns_show_ip=True\n\n",
		before=>File_Line['database'],
	}
	
	file_line { 'database':
	        path=>'/opt/biocloud/puppet/t1',
		line=>"#DATABASE\n[database]\nconnection = mysql://novadbadmin:novasecret@${ipaddress_eth0}/nova\n\n",
	        before=>File_Line['keystone'],
	}
	
	file_line { 'keystone':
	        path=>'/opt/biocloud/puppet/t1',
	        line=>"#KEYSTONE\n[keystone_authtoken]\nauth_uri = http://${ipaddress_eth0}:5000\nauth_host = ${ipaddress_eth0}\nauth_port = 35357\nauth_protocol = http\nadmin_tenant_name = service\nadmin_user = nova\nadmin_password = nova",
	} 
}
