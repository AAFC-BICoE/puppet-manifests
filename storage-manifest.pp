include dockerswift::dockersetup
include dockerswift::swiftstorage
Class['dockerswift::dockersetup'] -> Class['dockerswift::swiftstorage']
