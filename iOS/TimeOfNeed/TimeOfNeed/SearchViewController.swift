//
//  SearchViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 4/4/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet var searchResults: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var active = false
    var serviceLocations = Array<String>()
    var filteredLocations : [String] = []
    
    override func viewDidLoad() {
        for location in serviceData {
            serviceLocations.append(location["name"] as! String)
        }
        reformatTable()
        filteredLocations = serviceLocations
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchResults.rowHeight = 75
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        active = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        active = false
        reformatTable()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        active = false
        reformatTable()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        active = false
        reformatTable()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLocations = serviceLocations.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        active = filteredLocations.count != 0
        dispatch_async(dispatch_get_main_queue()) {
            self.searchResults.reloadData()
        }
        searchResults.rowHeight = 75
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if active {
            return filteredLocations.count
        }
        return serviceLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResults.dequeueReusableCellWithIdentifier("searchResult")! as! SearchViewCell

        let locations = active ? filteredLocations : serviceLocations
        cell.locationName.text = locations[indexPath.row]
        
        var serviceNames = [UILabel]()
        var serviceBackgrounds = [UIView]()
        for service in serviceData[serviceLocations.indexOf(locations[indexPath.row])!]["services"] as! [String] {
            let serviceBackground = UIView(frame: CGRectZero)
            serviceBackground.backgroundColor = UIColor.whiteColor()
            serviceBackground.layer.cornerRadius = 10
            serviceBackground.layer.borderWidth = 1
            serviceBackground.layer.borderColor = UIColor.blackColor().CGColor
            serviceBackgrounds.append(serviceBackground)
            let serviceName = UILabel(frame: CGRectZero)
            serviceName.text = service
            serviceName.textAlignment = .Center
            serviceName.numberOfLines = service.componentsSeparatedByString(" ").count
            serviceName.adjustsFontSizeToFitWidth = true
            serviceName.minimumScaleFactor = 0.01
            serviceName.font = serviceName.font.fontWithSize(16) // Bigger than needed so it will scale down
            let gestureRecognizer = UITapGestureRecognizer(target: serviceName, action: "showServiceLocation:")
            serviceName.addGestureRecognizer(gestureRecognizer)
            serviceNames.append(serviceName)
        }
        
        cell.servicesView.subviews.forEach({ $0.removeFromSuperview() }) // Remove old subviews before adding new ones
        
        let serviceBackgroundsStack = UIStackView(arrangedSubviews: serviceBackgrounds)
        serviceBackgroundsStack.axis = .Horizontal
        serviceBackgroundsStack.distribution = .FillEqually
        serviceBackgroundsStack.alignment = .Fill
        serviceBackgroundsStack.spacing = 5
        serviceBackgroundsStack.layer.bounds = CGRectMake(
            cell.servicesView.layer.bounds.minX, cell.servicesView.layer.bounds.minY, cell.servicesView.layer.bounds.size.width + 10, cell.servicesView.layer.bounds.height + 10
        )
        serviceBackgroundsStack.center = CGPoint(x: cell.servicesView.bounds.size.width / 2, y: cell.servicesView.bounds.size.height / 2)
        cell.servicesView.addSubview(serviceBackgroundsStack)

        let servicesStack = UIStackView(arrangedSubviews: serviceNames)
        servicesStack.axis = .Horizontal
        servicesStack.distribution = .FillEqually
        servicesStack.alignment = .Fill
        servicesStack.spacing = 15
        servicesStack.layer.bounds = cell.servicesView.layer.bounds
        servicesStack.center = CGPoint(x: cell.servicesView.bounds.size.width / 2, y: cell.servicesView.bounds.size.height / 2)
        cell.servicesView.addSubview(servicesStack)
        return cell;
    }
    
    func reformatTable() {
        dispatch_async(dispatch_get_main_queue()) {
            self.searchResults.reloadData()
        }
    }
    
    func showServiceLocations(sender: UITapGestureRecognizer) {
        
        serviceSelected = (sender.view as! UILabel).text!
        // Handle opening to specific location
        if (CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) || startingCoordinates.latitude != 0.0 {
            performSegueWithIdentifier("services", sender: nil)
        } else {
            var dialog = UIAlertController()
            dialog = UIAlertController(title: "Start location not set.", message: "Reference location needed.", preferredStyle: UIAlertControllerStyle.Alert)
            dialog.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })) // Cancel does nothing
            dialog.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action: UIAlertAction) in
                self.performSegueWithIdentifier("startLocation", sender: nil)
            }))
            self.presentViewController(dialog, animated: true, completion: nil)
        }

    }
}