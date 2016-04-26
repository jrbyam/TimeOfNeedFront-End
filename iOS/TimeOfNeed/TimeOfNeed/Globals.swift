//  Globals.swift

/*
    These are the global constants and variables used throughout the project.
*/

import CoreLocation

//  Global Constant
//  ---------------

let group = dispatch_group_create()

let labelNames : [String] = ["Shelter", "Food", "Clothing Closets / Assistance Programs", "Medical Facilities", "Support Groups", "Employment Assistance", "Transportation Assistance", "Shower Facilities", "Suicide Prevention", "Domestic Violence Resources", "Veteran Services", "Referal Services"]

let NOTREACHABLE: Int = 0

let pictureNames : [String] = ["shelter_icon.png", "food_icon.png", "clothing_icon.png", "medical_facilities_icon.png", "support_groups_icon.png", "employment_assistance_icon.png", "transportation_assistance_icon.png", "showers_icon.png", "suicide_prevention_icon.png", "domestic_violence_resources_icon.png", "veteran_services_icon.png", "referral_services_icon.png"]

//  Global Variable
//  ---------------

var cannotContinue = false

var connectedToServer = true 

var displayOldData = false

var locationToShow = ""

var netStatus = reachability.currentReachabilityStatus()

var networkConnected = true

var reachability = Reachability.reachabilityForInternetConnection()

var serviceData = Array<NSMutableDictionary>()

var servicesCoordinates = Array<CLLocationCoordinate2D>()

var serviceSelected = ""

var startingCoordinates = CLLocationCoordinate2D()
