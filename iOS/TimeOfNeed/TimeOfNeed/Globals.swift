//  Globals.swift

/*
    These are the global constants and variables used throughout the project.
*/

import CoreLocation

//  Global Constant
//  ---------------

let group = dispatch_group_create()

let NOTREACHABLE: Int = 0

//  Global Variable
//  ---------------

var cannotContinue = false

var connectedToServer = true 

var displayOldData = false

var netStatus = reachability.currentReachabilityStatus()

var networkConnected = true

var reachability = Reachability.reachabilityForInternetConnection()

var serviceData = Array<NSMutableDictionary>()

var servicesCoordinates = Array<CLLocationCoordinate2D>()

var serviceSelected = ""

var startingCoordinates = CLLocationCoordinate2D()
