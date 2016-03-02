//
//  SettingsTableViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/29/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBAction func backToMain(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1) {
            performSegueWithIdentifier("address", sender: nil)
        } else if (indexPath.row == 2) {
            performSegueWithIdentifier("categories", sender: nil)
        }
    }
}

