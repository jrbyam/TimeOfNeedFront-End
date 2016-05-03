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
        showQuickClose.addTarget(self, action: #selector(SettingsTableViewController.switchFlipped(_:)), forControlEvents: UIControlEvents.ValueChanged)
        showQuickClose.on = (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Add tool bar buttons
        var toolBarItemList = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(MainViewController.search)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ]
        if (NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool) == true {
            toolBarItemList.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(MainViewController.quickKill)))
        }
        self.toolbarItems = toolBarItemList
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1) {
            performSegueWithIdentifier("address", sender: nil)
        } else if (indexPath.row == 2) {
            performSegueWithIdentifier("categories", sender: nil)
        } else if (indexPath.row == 3) {
            performSegueWithIdentifier("contact", sender: nil)
        }
    }
    
    func switchFlipped(showQuickClose: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showQuickKill") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showQuickKill")
        viewDidAppear(true)
    }
    
/*
     Tool Bar Functions:
*/
    func search() {
        performSegueWithIdentifier("search", sender: nil)
    }
    
    func quickKill() {
        exit(0) // Sweet and simple
    }
}

