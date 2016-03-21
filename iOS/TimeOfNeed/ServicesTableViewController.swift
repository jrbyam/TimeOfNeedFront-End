//
//  ServicesTableViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/15/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class ServicesTableViewController: UITableViewController {
    
/*
    Class Constants
*/
    let cellID = "location"
/*
    Class Variables
*/
    var serviceLocations : [NSDictionary] = [NSDictionary]()
    var selectedIndexPath: NSIndexPath?
    var expandCurrentCell: Bool = false;
    
/*
    Class Functions
*/
    override func viewDidLoad() {
        for location : NSDictionary in (NSUserDefaults.standardUserDefaults().objectForKey("serviceData") as! [NSDictionary]) {
            for service : String in (location["services"] as! [String]) {
                if (service == serviceSelected) {
                    serviceLocations += [location];
                    break;
                }
            }
        }
        print (serviceLocations)
    }
/*
    TableView Functions
*/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ServicesTableViewCell
        cell.serviceName.text = (serviceLocations[indexPath.row]["name"] as! String)
//        cell.distance.text = serviceLocations[indexPath.row]["distance"]
        cell.phoneNumber.text = (serviceLocations[indexPath.row]["phone"] as! String)
//        cell.hoursTimes.text = serviceLocations[indexPath.row]["hours"]
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("showExtraInfo:"))
        cell.moreArrow.userInteractionEnabled = true
        cell.moreArrow.addGestureRecognizer(tapGestureRecognizer)
        cell.serviceDescription.text = "This is the cool description. It's descriptive. It describes this service. If you'd like to know more, check out our website below."
        cell.website.text = (serviceLocations[indexPath.row]["website"] as! String)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath { // Current already selected
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
            expandCurrentCell = false;
        }
        
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ServicesTableViewCell).watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            if expandCurrentCell {
                return ServicesTableViewCell.expandedHeight
            }
            return ServicesTableViewCell.quickLookHeight
        }
        return ServicesTableViewCell.defaultHeight
    }
    
    func showExtraInfo(sender: UITapGestureRecognizer) {
        // Using sender, get the point in respect to the table view
        let tapLocation = sender.locationInView(self.tableView)
        // Using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        selectedIndexPath = indexPath
        expandCurrentCell = true;
        tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
    }
}
