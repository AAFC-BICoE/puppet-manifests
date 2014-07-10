import 'zfs.pp'

class zfs::installer (
	$vdevs=undef, 
	$mirrors="", 
	$zpool_name="zpool1",
	$fs_name="storage",
	$mountpoint="/$zpool_name/$fs_name",
	$raid_parity="1", 
	$vdev_spare="",
	$readonly="off",
	$sharenfs="off",
	$sharesmb="off"
	$dedup="off" ) {

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
		ensure => present,
		dedup => $dedup,
		mountpoint => $mountpoint,
		readonly => $readonly,
		sharenfs => $sharenfs,
		sharesmb => $sharesmb,
	}

}
