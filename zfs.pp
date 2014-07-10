# == Class: dkms
#
# This module installs and configures DKMS.
#
# === Parameters
#
# None.
#
# === Variables
#
# None.
#
# === Examples
#
#  class { dkms: }
#
# === Authors
#
# Arnaud Gomes-do-Vale <Arnaud.Gomes@ircam.fr>
#
# === Copyright
#
# Copyright 2013 Arnaud Gomes-do-Vale
#
class dkms {

  include gcc

  case $::operatingsystem {
    redhat, centos: {
      # We need kernel-devel for DKMS.
      if !defined(Package['kernel-devel']) {
        package { 'kernel-devel':
          ensure => present,
          before => Package['dkms'],
        }
      }

      package { 'dkms':
        ensure => present,
      } ->
      service { 'dkms_autoinstaller':
        enable  => true,
        require => Class['gcc'],
      }
    }
    debian, ubuntu: {
      package { 'dkms':
        ensure => present,
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}.")
    }
  }

}


class zfs (
	$scrub_frequency = undef,
	$fuse = false,
) {

  case $::operatingsystem {
    redhat, centos: {
      include dkms

      package { 'zfs-release':
        ensure   => present,
        provider => rpm,
        source   => 'http://archive.zfsonlinux.org/epel/zfs-release-1-2.el6.noarch.rpm',
      } ->
      package { 'zfs':
        ensure => present,
        notify => Class['dkms'],
      } ~>
      service { 'zfs':
        ensure    => running,
        enable    => true,
        subscribe => Class['dkms'],
      }
    }
    ubuntu: {
      include apt
      if $fuse { 

        package { 'zfs-fuse':
          ensure => present,
        }

      } else {

       apt::ppa { 'ppa:zfs-native/stable': }

       package {'ubuntu-zfs':
         ensure => latest,
       }
       package {'zfs-auto-snapshot':
         ensure => latest,
       }
     }
   }
   default: {
     fail("Module ${module_name} does not support ${operatingsystem}.")
   }
}


}
