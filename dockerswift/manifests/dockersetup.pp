#NOTE - This class is, for now, only compatible with Debian-based distros. This is because the Dockerfiles I made use features that are only available in Docker 1.0 or higher, which was only just released and such is still in developer PPAs.

class dockerswift::dockersetup {
        #Get the key
        exec { 'docker-key':
                command=>'/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9',
                before=>File['docker.list'],
        }

        #Create sources.list.d file
        file { 'docker.list':
                path=>'/etc/apt/sources.list.d/docker.list',
                ensure=>present,
                mode=>0644, #mode sets permissions for the new file, 0644 is the desired permission for a sources.list.d file
                content=>"deb https://get.docker.io/ubuntu docker main",
                before=>Exec['update'],
        }

        #Run an apt-get update
        exec { 'update':
                command=>'/usr/bin/apt-get update',
                before=>Exec['lxc-docker'],
        }

        #Install docker
        exec { 'lxc-docker':
                command=>'/usr/bin/apt-get install -y lxc-docker',
        }

        #Ensure that dnsmasq is disabled. This is required for Docker containers to be able to access the internet.
        #This ensures that the dns=dnsmasq line in NetworkManager.conf is commented out
        file_line { 'dnsmasq':
                path=>'/etc/NetworkManager/NetworkManager.conf',
                line=>'#dns=dnsmasq',
                match=>'dns=dnsmasq',
        }
}
