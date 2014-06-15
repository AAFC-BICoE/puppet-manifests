import 'zfs.pp'

class zfs::installer ($zpool_name="zpool1", $fs_name="storage", $vdevs=undef, $mirrors="", $raid_parity="1", spare) {
	require zfs

        zpool { "$zpool_name":
                ensure => present,
                disk => $vdevs,
                mirror => $mirrors,
                raid_parity => $raid_parity,
                spare => $vdev_spare,
		before => Zfs["$zpool_name/$fs_name"],
        }


	zfs { "$zpool_name/$fs_name":
		
	}

}
