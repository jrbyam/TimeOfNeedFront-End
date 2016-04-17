//
//  SettingsCategoryTableViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 3/1/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class SettingsCategoryTableViewController: UITableViewController {
    
/*
    Class Constants
*/
    let cellID = "category"
    let labelNames : [String] = ["Shelter", "Food", "Clothing", "Medical Facilities", "Support Groups", "Employment Assistance", "Transportation Assistance", "Showers", "Suicide Prevention", "Domestic Violence Resources", "Veteran Services", "Referal Services"]
    let pictureNames : [String] = ["shelter_icon.png", "food_icon.png", "clothing_icon.png", "medical_facilities_icon.png", "support_groups_icon.png", "employment_assistance_icon.png", "transportation_assistance_icon.png", "showers_icon.png", "suicide_prevention_icon.png", "domestic_violence_resources_icon.png", "veteran_services_icon.png", "referral_services_icon.png"]
    
/*
    TableView Functions
*/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! SettingsCategoryTableViewCell
        cell.categoryImage.image = UIImage(named: pictureNames[indexPath.row])
        cell.categoryName.text = labelNames[indexPath.row]
        // Handle each switch
        cell.categorySwitch.addTarget(self, action: Selector("switchFlipped:"), forControlEvents: UIControlEvents.ValueChanged)
        if NSUserDefaults.standardUserDefaults().valueForKey("show" + (cell.categoryName.text!).removeWhitespace()) != nil {
            cell.categorySwitch.on = (NSUserDefaults.standardUserDefaults().valueForKey("show" + (cell.categoryName.text!).removeWhitespace()) as! Bool)
        }
        return cell
    }
    
/*
    Switch Function
*/
    func switchFlipped(categorySwitch: UISwitch) {
        let categoryName = (categorySwitch.superview?.superview as! SettingsCategoryTableViewCell).categoryName.text!
        if NSUserDefaults.standardUserDefaults().valueForKey("show" + categoryName.removeWhitespace()) == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "show" + categoryName.removeWhitespace()) // Default to true
        }
        
        // Toggle the value
        let currentValue = (NSUserDefaults.standardUserDefaults().valueForKey("show" + categoryName.removeWhitespace()) as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(!currentValue, forKey: "show" + categoryName.removeWhitespace())
    }
}