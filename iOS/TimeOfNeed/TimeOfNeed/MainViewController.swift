//
//  MainViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 3/21/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class MainViewController: UIViewController  {
    
/*
    Outlets:
*/
    @IBOutlet weak var shelter: UIView!
    @IBOutlet weak var food: UIView!
    @IBOutlet weak var clothing: UIView!
    @IBOutlet weak var medicalFacilities: UIView!
    @IBOutlet weak var supportGroups: UIView!
    @IBOutlet weak var employmentAssistance: UIView!
    @IBOutlet weak var transportationAssistance: UIView!
    @IBOutlet weak var showers: UIView!
    @IBOutlet weak var suicidePrevention: UIView!
    @IBOutlet weak var domesticViolenceResources: UIView!
    @IBOutlet weak var veteranServices: UIView!
    @IBOutlet weak var referalServices: UIView!
    @IBOutlet var topRow: UIStackView!
    @IBOutlet var secondRow: UIStackView!
    @IBOutlet var thirdRow: UIStackView!
    @IBOutlet var bottomRow: UIStackView!
    
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
        
        // Add tap gestrues to each of the service selection views (they each need their own)
        let gesture1 = UITapGestureRecognizer(target: self, action: "showServices:")
        shelter.addGestureRecognizer(gesture1)
        let gesture2 = UITapGestureRecognizer(target: self, action: "showServices:")
        food.addGestureRecognizer(gesture2)
        let gesture3 = UITapGestureRecognizer(target: self, action: "showServices:")
        clothing.addGestureRecognizer(gesture3)
        let gesture4 = UITapGestureRecognizer(target: self, action: "showServices:")
        medicalFacilities.addGestureRecognizer(gesture4)
        let gesture5 = UITapGestureRecognizer(target: self, action: "showServices:")
        supportGroups.addGestureRecognizer(gesture5)
        let gesture6 = UITapGestureRecognizer(target: self, action: "showServices:")
        employmentAssistance.addGestureRecognizer(gesture6)
        let gesture7 = UITapGestureRecognizer(target: self, action: "showServices:")
        transportationAssistance.addGestureRecognizer(gesture7)
        let gesture8 = UITapGestureRecognizer(target: self, action: "showServices:")
        showers.addGestureRecognizer(gesture8)
        let gesture9 = UITapGestureRecognizer(target: self, action: "showServices:")
        suicidePrevention.addGestureRecognizer(gesture9)
        let gesture10 = UITapGestureRecognizer(target: self, action: "showServices:")
        domesticViolenceResources.addGestureRecognizer(gesture10)
        let gesture11 = UITapGestureRecognizer(target: self, action: "showServices:")
        veteranServices.addGestureRecognizer(gesture11)
        let gesture12 = UITapGestureRecognizer(target: self, action: "showServices:")
        referalServices.addGestureRecognizer(gesture12)
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
        
        // Hide/Show categories according to the settings
        shelter.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showShelter") as! Bool)
        food.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showFood") as! Bool)
        clothing.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showClothing") as! Bool)
        medicalFacilities.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showMedicalFacilities") as! Bool)
        supportGroups.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showSupportGroups") as! Bool)
        employmentAssistance.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showEmploymentAssistance") as! Bool)
        transportationAssistance.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showTransportationAssistance") as! Bool)
        showers.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showShowers") as! Bool)
        suicidePrevention.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showSuicidePrevention") as! Bool)
        domesticViolenceResources.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showDomesticViolenceResources") as! Bool)
        veteranServices.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showVeteranServices") as! Bool)
        referalServices.hidden = !(NSUserDefaults.standardUserDefaults().valueForKey("showReferalServices") as! Bool)
        topRow.hidden = shelter.hidden && food.hidden && clothing.hidden
        secondRow.hidden = medicalFacilities.hidden && supportGroups.hidden && employmentAssistance.hidden
        thirdRow.hidden = transportationAssistance.hidden && showers.hidden && suicidePrevention.hidden
        bottomRow.hidden = domesticViolenceResources.hidden && veteranServices.hidden && referalServices.hidden
    }
    
/*
    Helper Functions:
*/
    // showServices
    // This function simply seques to the services scene 
    func showServices(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("services", sender: nil)
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