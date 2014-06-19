class dockerswift {
	include dockerswift::dockersetup
	include dockerswift::swiftproxy
	include dockerswift::swiftstorage
}
