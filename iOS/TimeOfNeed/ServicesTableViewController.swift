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
    let foodServices: [[String: String]] =  [   [   "name"              : "Stone Soup Cafe",
        "address"           : "507 Gaffney Road",
        "city"              : "Fairbanks",
        "state"             : "AK",
        "zip code"          : "99701",
        "hours"             : "9am-5pm",
        "phone number"      : "907-456-8317",
        "phone extension"   : "",
        "website"           : "www.stonesoupcafe.org",
        "distance"          : "0.2" ],
        [   "name"              : "Fairbanks Rescue Mission",
            "address"           : "723 27th Street",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "8am-5pm",
            "phone number"      : "907-452-5343",
            "phone extension"   : "",
            "website"           : "",
            "distance"          : "0.4" ],
        [   "name"              : "Immaculate Conception Church",
            "address"           : "2 Doyon Place",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "12pm-5pm",
            "phone number"      : "907-456-5656",
            "phone extension"   : "",
            "website"           : "",
            "distance"          : "0.9" ],
        [   "name"              : "The Salvation Army",
            "address"           : "2222 S. Cushman Street",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "9am-5pm",
            "phone number"      : "907-456-5656",
            "phone extension"   : "",
            "website"           : "",
            "distance"          : "1.2" ],
        [   "name"              : "FNA Elders Program",
            "address"           : "317 Wendell Street",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "8am-5pm",
            "phone number"      : "907-456-5656",
            "phone extension"   : "",
            "website"           : "",
            "distance"          : "2.5" ],
        [   "name"              : "North Star Council On Aging",
            "address"           : "1424 Moore Street",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "8am-5pm",
            "phone number"      : "907-456-5656",
            "phone extension"   : "",
            "website"           : "",
            "distance"          : "2.8" ],
        [   "name"              : "Fairbanks Food Bank",
            "address"           : "725 26th Avenue",
            "city"              : "Fairbanks",
            "state"             : "AK",
            "zip code"          : "99701",
            "hours"             : "6am-6pm",
            "phone number"      : "907-456-2990",
            "phone extension"   : "101",
            "website"           : "www.fairbanksfoodbank.org",
            "distance"          : "3.1" ]
    ]
/*
    Class Variables
*/
    var selectedIndexPath: NSIndexPath?
    var expandCurrentCell: Bool = false;
    
/*
    Class Functions
*/
    override func viewDidLoad() {
    }
/*
    TableView Functions
*/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodServices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ServicesTableViewCell
        cell.serviceName.text = foodServices[indexPath.row]["name"]
        cell.distance.text = foodServices[indexPath.row]["distance"]
        cell.phoneNumber.text = foodServices[indexPath.row]["phone number"]
        cell.hoursTimes.text = foodServices[indexPath.row]["hours"]
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("showExtraInfo:"))
        cell.moreArrow.userInteractionEnabled = true
        cell.moreArrow.addGestureRecognizer(tapGestureRecognizer)
        cell.serviceDescription.text = "This is the cool description. It's descriptive. It describes this service. If you'd like to know more, check out our website below."
        cell.website.text = foodServices[indexPath.row]["website"]
        if cell.website.text == "" {
            cell.website.text = "www.website.org"
        }
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
