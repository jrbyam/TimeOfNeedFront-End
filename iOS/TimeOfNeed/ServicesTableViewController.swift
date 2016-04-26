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

class ServicesTableViewController: UITableViewController, MKMapViewDelegate {
    
/*
    Class Constants
*/
    let cellID = "location"
    let dropPin = MKPointAnnotation()
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
        var locationsWithoutAddresses = [NSMutableDictionary]()
        for location : NSMutableDictionary in serviceData {
            for service : String in (location["services"] as! [String]) {
                if (service == serviceSelected) {
                    if (location["address_line1"] != nil && (location["address_line1"] as! NSString).substringToIndex(4) != "P.O.") {
                        serviceLocations += [location]
                    } else {
                        locationsWithoutAddresses += [location]
                    }
                    break;
                }
            }
        }
        // Sort locations according to distance from set starting location
        if serviceLocations.count > 1 {
            serviceLocations.sortInPlace({ (servicesCoordinates[serviceData.indexOf($0)!]).distanceInMetersFrom(startingCoordinates) <
                (servicesCoordinates[serviceData.indexOf($1)!]).distanceInMetersFrom(startingCoordinates) })
        }
        serviceLocations = locationsWithoutAddresses + serviceLocations // Add address-less locations to top of list
        
        if (locationToShow != "") {
            var idx = 0;
            for location in serviceLocations {
                if (location["name"] as! String) == locationToShow { break }
                ++idx
            }
            let scrollPath = NSIndexPath(forItem: idx, inSection: 0)
            self.tableView(self.tableView, didSelectRowAtIndexPath: scrollPath)
            self.tableView.scrollToRowAtIndexPath(scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            locationToShow = ""
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if serviceLocations.count == 0 {
            let sorry = UILabel(frame: CGRect.zero)
            sorry.text = "Sorry, there are no locations with this service."
            sorry.numberOfLines = 4
            sorry.textAlignment = .Center
            sorry.layer.bounds = self.view.layer.bounds
            sorry.center = CGPoint(x: self.view.layer.bounds.size.width / 2, y: self.view.layer.bounds.size.height / 2)
            self.view.addSubview(sorry)
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.serviceName.text = (serviceLocations[indexPath.row]["name"] as! String)
        cell.distance.text = String(format:"%.2f",
            (servicesCoordinates[(serviceData.indexOf(serviceLocations[indexPath.row]))!]).distanceInMetersFrom(startingCoordinates) * 0.000621371) // Convert to miles
        if serviceLocations[indexPath.row]["phone"] != nil {
            cell.phoneNumber.text = (serviceLocations[indexPath.row]["phone"] as! String)
            cell.phoneNumber.userInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "callNumber:")
            cell.phoneNumber.addGestureRecognizer(gestureRecognizer)
        } else  {
            cell.phoneNumber.text = "N/A"
            cell.phoneNumber.userInteractionEnabled = false
        }
        
        cell.noMapView.hidden = false
        cell.distance.hidden = true
        cell.mi.hidden = true
        if serviceLocations[indexPath.row]["address_line1"] != nil {
            cell.address.text! = (serviceLocations[indexPath.row]["address_line1"] as! String)
            if serviceLocations[indexPath.row]["address_line2"] != nil {
                cell.address.text! += ", " + (serviceLocations[indexPath.row]["address_line2"] as! String)
            }
            if serviceLocations[indexPath.row]["address_line3"] != nil {
                cell.address.text! += ", " + (serviceLocations[indexPath.row]["address_line3"] as! String)
            }
            cell.address.userInteractionEnabled = true
            cell.address.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openMapsByAddressTouch:"))
            
            if (serviceLocations[indexPath.row]["address_line1"] as! NSString).substringToIndex(4) != "P.O." {
                cell.noMapView.hidden = true
                cell.distance.hidden = false
                cell.mi.hidden = false
                // Set map to correct location
                let region = MKCoordinateRegion(center: servicesCoordinates[serviceData.indexOf(serviceLocations[indexPath.row])!],
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                cell.mapView.setRegion(region, animated: true)
                // Drop a pin
                dropPin.coordinate = servicesCoordinates[serviceData.indexOf(serviceLocations[indexPath.row])!]
                cell.mapView.addAnnotation(dropPin)
                cell.mapView.userInteractionEnabled = true
                cell.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openMapsByMapTouch:"))
            }
        } else {
            cell.address.text = "N/A"
            cell.address.userInteractionEnabled = false
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("showExtraInfo:"))
        cell.moreArrow.userInteractionEnabled = true
        cell.moreArrow.addGestureRecognizer(tapGestureRecognizer)
        cell.serviceDescription.text = "This is the cool description. It's descriptive. It describes this service. If you'd like to know more, check out our website below."
        if serviceLocations[indexPath.row]["website"] != nil {
            cell.website.hidden = false
            cell.website.text = (serviceLocations[indexPath.row]["website"] as! String)
            cell.website.userInteractionEnabled = true
            cell.website.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openWebsite:"))
        } else {
            cell.website.hidden = true
            cell.website.userInteractionEnabled = false
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath != selectedIndexPath {
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
    
    func callNumber(sender: UITapGestureRecognizer) {
        (sender.view as! UILabel).textColor = UIColor.blueColor()
        let number = (sender.view as! UILabel).text
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + number!)!)
    }
    
    func openMapsByAddressTouch(sender: UITapGestureRecognizer) {
        let address = (sender.view as! UILabel).text?.replace(" ", replacement: "+")
        let targetURL = NSURL(string: "http://maps.apple.com/?q=" + address!)!
        UIApplication.sharedApplication().openURL(targetURL)
    }
    
    func openMapsByMapTouch(sender: UITapGestureRecognizer) {
        let address = (sender.view!.superview?.superview?.superview as! ServicesTableViewCell).address.text?.replace(" ", replacement: "+")
        let targetURL = NSURL(string: "http://maps.apple.com/?q=" + address!)!
        UIApplication.sharedApplication().openURL(targetURL)
    }
    
    func openWebsite(sender: UITapGestureRecognizer) {
        var urlText = (sender.view as! UILabel).text!
        if (urlText as NSString).substringToIndex(4) != "http" { urlText = "http://" + urlText }
        let urlToLoad = NSURL(string: urlText)
        UIApplication.sharedApplication().openURL(urlToLoad!)
    }
}
