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
    @IBOutlet weak var sexTraffickingResources: UIView!
    
/*
    Class Functions:
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        sexTraffickingResources.addGestureRecognizer(gesture12)
        
        // Add tool bar buttons
        self.toolbarItems = [UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "settings"), // Settings Icon
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "search"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "quickKill") ]
    }
    
/*
    Helper Functions:
*/
    func showServices(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("services", sender: nil)
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