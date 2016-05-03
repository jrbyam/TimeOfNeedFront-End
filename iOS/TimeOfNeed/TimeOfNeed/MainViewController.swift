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
/*
    Outlets:
*/
    @IBOutlet var container: UIView!
    @IBOutlet var loadingScreen: UIView!

/*
    Class Functions:
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        container.userInteractionEnabled = false
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
        for labelName in labelNames {
            if NSUserDefaults.standardUserDefaults().valueForKey("show" + labelName.removeWhitespace()) == nil {
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "show" + labelName.removeWhitespace())
            }
        }
        
        // If not already granted, ask for permission to use current location
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Get starting location from defautls if it is set
        if NSUserDefaults.standardUserDefaults().objectForKey("startingCoordinates") != nil {
            let startingCoordinatesDict = NSUserDefaults.standardUserDefaults().objectForKey("startingCoordinates") as! Dictionary<String, NSNumber>
            startingCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(startingCoordinatesDict["latitude"]!), longitude: CLLocationDegrees(startingCoordinatesDict["longitude"]!))
        } else if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            //startingCoordinates = (locationManager.location?.coordinate)!
        }
        
        // Hide loading screen when done loading.
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.loadingScreen.hidden = true
            self.container.userInteractionEnabled = true // Make menu selectable when loading screen hides
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Add tool bar buttons
        var toolBarItemList = [ UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.settings)), // Settings Icon
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(MainViewController.search)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ]
        if (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool) == true {
            toolBarItemList.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(MainViewController.quickKill)))
        }
        self.toolbarItems = toolBarItemList
        
        // Set the main menu category buttons
        container.subviews.forEach({ $0.removeFromSuperview() }) // Remove any subviews that were added before
        var categoriesToShow = [String]()
        var picturesToShow = [String]()
        var idx = 0
        for labelName in labelNames {
            if NSUserDefaults.standardUserDefaults().valueForKey("show" + labelName.removeWhitespace()) as! Bool {
                categoriesToShow.append(labelName)
                picturesToShow.append(pictureNames[idx])
            }
            idx += 1
        }
        var contentRowStacks = [UIStackView]()
        var backgroundRowStacks = [UIStackView]()
        var rows = categoriesToShow.count / 3;
        if categoriesToShow.count % 3 != 0 { rows += 1; }
        idx = 0
        for (var i = 0; i < rows; i += 1) {
            var categoryViews = [UIStackView]()
            var categoryBackgrounds = [UIView]()
            var itemsInRow = 3;
            if categoriesToShow.count - idx == 4 { itemsInRow -= 1; } // If there are 4 left, put 2 in each of the last 2 rows
            for (var j = 0; j < itemsInRow; ++j) {
                if (idx < categoriesToShow.count) {
                    let categoryBackground = UIView(frame: CGRectZero)
                    categoryBackground.backgroundColor = UIColor.whiteColor()
                    categoryBackground.layer.cornerRadius = 20
                    categoryBackground.layer.borderWidth = 1
                    categoryBackground.layer.borderColor = UIColor.blackColor().CGColor
                    categoryBackgrounds.append(categoryBackground)
                    // Add ImageView and Label to a StackView to add to categoryViews
                    let categoryName = UILabel(frame: CGRectZero)
                    categoryName.text = categoriesToShow[idx]
                    categoryName.textAlignment = .Center
                    categoryName.numberOfLines = categoriesToShow[idx].componentsSeparatedByString(" ").count + 1 // One word per line
                    categoryName.adjustsFontSizeToFitWidth = true
                    categoryName.minimumScaleFactor = 0.01
                    categoryName.font = categoryName.font.fontWithSize(60) // Bigger than needed so it will scale down
                    let categoryImage = UIImageView(image: UIImage(named: picturesToShow[idx]))
                    categoryImage.contentMode = .ScaleAspectFit
                    let categoryStack = UIStackView(arrangedSubviews: [categoryImage, categoryName])
                    categoryStack.axis = .Vertical
                    categoryStack.distribution = .FillEqually
                    categoryStack.alignment = .Fill
                    categoryStack.spacing = 5
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: "showServices:")
                    categoryStack.addGestureRecognizer(gestureRecognizer)
                    categoryViews.append(categoryStack)
                }
                idx++;
            }
            let contentRowStack = UIStackView(arrangedSubviews: categoryViews)
            contentRowStack.axis = .Horizontal
            contentRowStack.distribution = .FillEqually
            contentRowStack.alignment = .Fill
            contentRowStack.spacing = 15
            contentRowStacks.append(contentRowStack)
            let backgroundRowStack = UIStackView(arrangedSubviews: categoryBackgrounds)
            backgroundRowStack.axis = .Horizontal
            backgroundRowStack.distribution = .FillEqually
            backgroundRowStack.alignment = .Fill
            backgroundRowStack.spacing = 5
            backgroundRowStacks.append(backgroundRowStack)
        }
        let backgroundVerticalStack = UIStackView(arrangedSubviews: backgroundRowStacks)
        backgroundVerticalStack.backgroundColor = UIColor.redColor()
        backgroundVerticalStack.axis = .Vertical
        backgroundVerticalStack.distribution = .FillEqually
        backgroundVerticalStack.alignment = .Fill
        backgroundVerticalStack.spacing = 5
        backgroundVerticalStack.layer.bounds = CGRectMake(container.layer.bounds.minX, container.layer.bounds.minY, container.layer.bounds.size.width + 10, container.layer.bounds.height + 10)
        backgroundVerticalStack.center = CGPoint(x: container.bounds.size.width / 2, y: container.bounds.size.height / 2)
        container.addSubview(backgroundVerticalStack)
        let contentVerticalStack = UIStackView(arrangedSubviews: contentRowStacks)
        contentVerticalStack.backgroundColor = UIColor.redColor()
        contentVerticalStack.axis = .Vertical
        contentVerticalStack.distribution = .FillEqually
        contentVerticalStack.alignment = .Fill
        contentVerticalStack.spacing = 15
        contentVerticalStack.layer.bounds = container.layer.bounds
        contentVerticalStack.center = CGPoint(x: container.bounds.size.width / 2, y: container.bounds.size.height / 2)
        container.addSubview(contentVerticalStack)
    }
    
/*
    Helper Functions:
*/
    // showServices
    // This function simply seques to the services scene 
    func showServices(sender: UITapGestureRecognizer) {
        serviceSelected = ((sender.view as! UIStackView).arrangedSubviews.last as! UILabel).text!
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