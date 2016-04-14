//
//  MainViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 3/21/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController  {
  
    let locationManager = CLLocationManager()
    let labelNames : [String] = ["Shelter", "Food", "Clothing", "Medical Facilities", "Support Groups", "Employment Assistance", "Transportation Assistance", "Showers", "Suicide Prevention", "Domestic Violence Resources", "Veteran Services", "Referal Services"]
    let pictureNames : [String] = ["shelter_icon.png", "food_icon.png", "clothing_icon.png", "medical_facilities_icon.png", "support_groups_icon.png", "employment_assistance_icon.png", "transportation_assistance_icon.png", "showers_icon.png", "suicide_prevention_icon.png", "domestic_violence_resources_icon.png", "veteran_services_icon.png", "referral_services_icon.png"]
/*
    Outlets:
*/
    @IBOutlet var container: UIView!

/*
    Class Functions:
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check the network before continuing
        dispatch_async(dispatch_get_main_queue()) {
            if !networkConnected {
                self.checkNetwork()
            } else if !connectedToServer {
                if cannotContinue {
                    let alert = UIAlertController(title: "Unable to connect to server.", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.handleNoServerConnection()
                }
            }
        }
        
        // Initialize settings to defaults
        if (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showQuickKill")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showShelter") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showShelter")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showFood") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showFood")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showClothing") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showClothing")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showMedicalFacilities") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showMedicalFacilities")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showSupportGroups") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showSupportGroups")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showEmploymentAssistance") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showEmploymentAssistance")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showTransportationAssistance") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showTransportationAssistance")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showShowers") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showShowers")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showSuicidePrevention") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showSuicidePrevention")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showDomesticViolenceResources") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showDomesticViolenceResources")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showVeteranServices") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showVeteranServices")
        }
        if (NSUserDefaults.standardUserDefaults().valueForKey("showReferalServices") == nil) {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "showReferalServices")
        }
        
        // If not already granted, ask for permission to use current location
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Get starting location from defautls if it is set
        if NSUserDefaults.standardUserDefaults().objectForKey("startingCoordinates") != nil {
            let startingCoordinatesDict = NSUserDefaults.standardUserDefaults().objectForKey("startingCoordinates") as! Dictionary<String, NSNumber>
            startingCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(startingCoordinatesDict["latitude"]!), longitude: CLLocationDegrees(startingCoordinatesDict["latitude"]!))
        } else if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            startingCoordinates = (locationManager.location?.coordinate)!
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Add tool bar buttons
        var toolBarItemList = [ UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "settings"), // Settings Icon
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "search"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ]
        if (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool) == true {
            toolBarItemList.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "quickKill"))
        }
        self.toolbarItems = toolBarItemList
        
        // Set the main menu category buttons
        var rowStacks = [UIStackView]()
        var rows = labelNames.count / 3;
        if labelNames.count % 3 != 0 { rows++; }
        var idx = 0;
        for (var i = 0; i < rows; ++i) {
            var categoryViews = [UIStackView]()
            var itemsInRow = 3;
            if labelNames.count - idx == 4 { itemsInRow--; } // If there are 4 left, put 2 in each of the last 2 rows
            for (var j = 0; j < itemsInRow; ++j) {
                if (idx < labelNames.count) {
                    // Add ImageView and Label to StackView to add to categoryViews
                    let categoryName = UILabel(frame: CGRectZero)
                    categoryName.text = labelNames[idx]
                    categoryName.textAlignment = .Center
                    categoryName.numberOfLines = labelNames[idx].componentsSeparatedByString(" ").count // One word per line
                    categoryName.adjustsFontSizeToFitWidth = true
                    categoryName.minimumScaleFactor = 0.1
                    let categoryImage = UIImageView(image: UIImage(named: pictureNames[idx]))
                    categoryImage.contentMode = .ScaleAspectFit
                    let categoryStack = UIStackView(arrangedSubviews: [categoryImage, categoryName])
                    categoryStack.axis = .Vertical
                    categoryStack.distribution = .FillEqually
                    categoryStack.alignment = .Fill
                    categoryStack.spacing = 5
                    categoryViews.append(categoryStack)
                }
                idx++;
            }
            let rowStack = UIStackView(arrangedSubviews: categoryViews)
            rowStack.axis = .Horizontal
            rowStack.distribution = .FillEqually
            rowStack.alignment = .Fill
            rowStack.spacing = 15
            rowStacks.append(rowStack)
        }
        var verticalStack = UIStackView(arrangedSubviews: rowStacks)
        verticalStack.backgroundColor = UIColor.redColor()
        verticalStack.axis = .Vertical
        verticalStack.distribution = .FillEqually
        verticalStack.alignment = .Fill
        verticalStack.spacing = 15
        verticalStack.layer.bounds = container.layer.bounds
        verticalStack.center = CGPoint(x: container.bounds.size.width / 2, y: container.bounds.size.height / 2)
        // Add in each category background before adding to superview
//        var newRowStacks = [UIStackView]()
//        for row in verticalStack.arrangedSubviews {
//            var newCategoryViews = [UIView]()
//            for categoryStack in (row as! UIStackView).arrangedSubviews {
//                let categoryBackground = UIView(frame: categoryStack.bounds)
//                categoryBackground.layer.cornerRadius = 25
//                categoryBackground.layer.borderWidth = 2
//                categoryBackground.addSubview(categoryStack)
//                newCategoryViews.append(categoryBackground)
//            }
//            let newRowStack = UIStackView(arrangedSubviews: newCategoryViews)
//            newRowStack.axis = .Horizontal
//            newRowStack.distribution = .FillEqually
//            newRowStack.alignment = .Fill
//            newRowStack.spacing = 15
//            newRowStacks.append(newRowStack)
//        }
//        verticalStack = UIStackView(arrangedSubviews: newRowStacks)
        container.addSubview(verticalStack)
    }
    
/*
    Helper Functions:
*/
    // showServices
    // This function simply seques to the services scene 
    func showServices(sender: UITapGestureRecognizer) {
        if (CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) || startingCoordinates.latitude != 0.0 {
            performSegueWithIdentifier("services", sender: nil)
        } else {
            var dialog = UIAlertController()
            dialog = UIAlertController(title: "Start location not set.", message: "Reference location needed.", preferredStyle: UIAlertControllerStyle.Alert)
            dialog.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })) // Cancel does nothing
            dialog.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action: UIAlertAction) in
                self.performSegueWithIdentifier("startLocation", sender: nil)
            }))
            self.presentViewController(dialog, animated: true, completion: nil)
        }
    }
    // checkNetwork
    // This function checks the network status and engages in dialog with the user until the network situation is resolved
    func checkNetwork() {
        var alert = UIAlertController()
        if (NSUserDefaults.standardUserDefaults().objectForKey("serviceData") == nil) {
            alert = UIAlertController(title: "No internet connection.", message: "Internet required for initial startup.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: { (action: UIAlertAction) in
                netStatus = reachability.currentReachabilityStatus()
                if (netStatus.rawValue == NOTREACHABLE) {
                    self.checkNetwork()
                } else {
                    networkConnected = true
                }
            }))
        } else {
            alert = UIAlertController(title: "No internet connection.", message: "Content may not be up to date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            displayOldData = true
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // handleNoServerConnection
    func handleNoServerConnection() {
        let alert = UIAlertController(title: "Unable to connect to server.", message: "Content may not be up to date.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
/*
    Tool Bar Functions:
*/
    func settings() {
        performSegueWithIdentifier("settings", sender: nil)
    }
    
    func search() {
        performSegueWithIdentifier("search", sender: nil)
    }
    
    func quickKill() {
        exit(0) // Sweet and simple
    }
}