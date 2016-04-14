//
//  SettingsTableViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/29/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var showQuickClose: UISwitch!
    @IBAction func backToMain(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        showQuickClose.addTarget(self, action: Selector("switchFlipped:"), forControlEvents: UIControlEvents.ValueChanged)
        showQuickClose.on = (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1) {
            performSegueWithIdentifier("address", sender: nil)
        } else if (indexPath.row == 2) {
            performSegueWithIdentifier("categories", sender: nil)
        }
    }
    
    func switchFlipped(showQuickClose: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showQuickKill")
    }
}

