//
//  SearchViewController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 4/4/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchResults: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var active = false
    var serviceLocations = Array<String>()
    var filteredLocations : [String] = []
    
    override func viewDidLoad() {
        for location in serviceData {
            serviceLocations.append(location["name"] as! String)
        }
        filteredLocations = serviceLocations
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        active = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        active = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        active = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        active = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLocations = serviceLocations.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        active = filteredLocations.count != 0
        searchResults.reloadData()
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
        let cell = searchResults.dequeueReusableCellWithIdentifier("searchResult")! as! SearchTableViewCell;

        
        if active {
            cell.locationName.text = filteredLocations[indexPath.row]
            //serviceDict = serviceData[serviceLocations.indexOf(filteredLocations[indexPath.row])!]
        } else {
            cell.locationName.text = serviceLocations[indexPath.row];
            //serviceDict = serviceData[indexPath.row]
        }
        
//        for service in (serviceDict["services"] as! [String]) {
//            print (service)
//            if service == "Shelter" {
//                shelter = true
//            } else if service == "Food" {
//                food = true
//            } else if service == "Clothing" {
//                clothing = true
//            } else if service == "Medical Facilities" {
//                medicalFacilities = true
//            } else if service == "Support Groups" {
//                supportGroups = true
//            } else if service == "Employemnt Assistance" {
//                employmentAssistance = true
//            } else if service == "Transportation Assistance" {
//                transportationAssistance = true
//            } else if service == "Showers" {
//                showers = true
//            } else if service == "Suicide Prevention" {
//                suicidePrevention = true
//            } else if service == "Domestic Violence Resources" {
//                domesticViolenceResources = true
//            } else if service == "Veteran Sercives" {
//                veteranServices = true
//            } else if service == "Referral Services" {
//                referralServices = true
//            }
//        }
//        
//        cell.shelter.hidden = !shelter
//        cell.food.hidden = !food
//        cell.clothing.hidden = !clothing
//        cell.medicalFacilities.hidden = !medicalFacilities
//        cell.supportGroups.hidden = !supportGroups
//        cell.employmentAssistance.hidden = !employmentAssistance
//        cell.transportationAssistance.hidden = !transportationAssistance
//        cell.showers.hidden = !showers
//        cell.suicidePrevention.hidden = !suicidePrevention
//        cell.domesticViolenceResources.hidden = !domesticViolenceResources
//        cell.veteranServices.hidden = !veteranServices
//        cell.referralServices.hidden = !referralServices

        return cell;
    }
}