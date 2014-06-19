include dockerswift::dockersetup
include dockerswift::swiftproxy
Class['dockerswift::dockersetup'] -> Class['dockerswift::swiftproxy']
