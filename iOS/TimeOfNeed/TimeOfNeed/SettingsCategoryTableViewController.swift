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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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