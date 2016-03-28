//
//  ServicesTableViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/15/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ServicesTableViewController: UITableViewController {
    
/*
    Class Constants
*/
    let cellID = "location"
/*
    Class Variables
*/
    var serviceLocations : [NSMutableDictionary] = [NSMutableDictionary]()
    var selectedIndexPath: NSIndexPath?
    var expandCurrentCell: Bool = false;
    
/*
    Class Functions
*/
    override func viewDidLoad() {
        for location : NSMutableDictionary in serviceData {
            for service : String in (location["services"] as! [String]) {
                if (service == serviceSelected) {
                    serviceLocations += [location];
                    break;
                }
            }
        }
        // Sort locations according to distance from set starting location
        if serviceLocations.count > 1 {
            serviceLocations.sortInPlace({ (servicesCoordinates[serviceData.indexOf($0)!]).distanceInMetersFrom(CLLocationCoordinate2DMake(64.856045, -147.736460)) <
                (servicesCoordinates[serviceData.indexOf($1)!]).distanceInMetersFrom(CLLocationCoordinate2DMake(64.856045, -147.736460)) })
        } else if serviceLocations.count == 0 {
            // Show a sorry message
        }
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
        cell.distance.text = String(format:"%.2f",
            (servicesCoordinates[(serviceData.indexOf(serviceLocations[indexPath.row]))!]).distanceInMetersFrom(CLLocationCoordinate2DMake(64.856045, -147.736460)) * 0.000621371) // Convert to miles
        if serviceLocations[indexPath.row]["phone"] != nil {
            cell.phoneNumber.text = (serviceLocations[indexPath.row]["phone"] as! String)
        }
//        cell.hoursTimes.text = serviceLocations[indexPath.row]["hours"]
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("showExtraInfo:"))
        cell.moreArrow.userInteractionEnabled = true
        cell.moreArrow.addGestureRecognizer(tapGestureRecognizer)
        cell.serviceDescription.text = "This is the cool description. It's descriptive. It describes this service. If you'd like to know more, check out our website below."
        if serviceLocations[indexPath.row]["website"] != nil {
            cell.website.text = (serviceLocations[indexPath.row]["website"] as! String)
        }
        // Set map to correct location
        CLGeocoder().geocodeAddressString((serviceLocations[indexPath.row]["address"] as! String), completionHandler: {(placemarks, error) -> Void in
            if (error) != nil {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                cell.mapView.setRegion(region, animated: true)
                // Drop a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = (self.serviceLocations[indexPath.row]["name"] as! String)
                cell.mapView.addAnnotation(dropPin)
            }
        })
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
