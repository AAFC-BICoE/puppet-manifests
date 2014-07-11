import 'zfs_installer.pp'

node datagrid-1 {
	class {"zfs_installer":
		raidz => ['/dev/disk/by-id/scsi-3600062b20054ac801b2c29cf33a5ecc1', '/dev/disk/by-id/scsi-3600062b20054ac801b2c28451c331b12', '/dev/disk/by-id/scsi-3600062b20054ac801b2c297a2e9a0e26', '/dev/disk/by-id/scsi-3600062b20054ac801b2c299e30c32bbd', '/dev/disk/by-id/scsi-3600062b20054ac801b2c2a1237a88a91'],
		zpool_name => "irods_pool",
		fs_name => "irods"
	}
}
