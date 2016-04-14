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
    let labelNames : [String] = ["Shelter", "Food", "Clothing", "Medical Facilities", "Support Groups", "Employment Assistance", "Transportation Assistance", "Showers", "Suicide Prevention", "Domestic Violence Resources", "Veteran Services", "Referal Services"]
    let pictureNames : [String] = ["shelter_icon.png", "food_icon.png", "clothing_icon.png", "medical_facilities_icon.png", "support_groups_icon.png", "employment_assistance_icon.png", "transportation_assistance_icon.png", "showers_icon.png", "suicide_prevention_icon.png", "domestic_violence_resources_icon.png", "veteran_services_icon.png", "referral_services_icon.png"]
    
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
        cell.categorySwitch.addTarget(self, action: Selector((cell.categoryName.text!).removeWhitespace() + "SwitchFlipped:"),
            forControlEvents: UIControlEvents.ValueChanged)
        cell.categorySwitch.on = (NSUserDefaults.standardUserDefaults().valueForKey("show" + (cell.categoryName.text!).removeWhitespace()) as! Bool)
        return cell
    }
    
/*
    Switch Functions
*/
    func ShelterSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showShelter") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showShelter")
    }
    func FoodSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showFood") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showFood")
    }
    func ClothingSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showClothing") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showClothing")
    }
    func MedicalFacilitiesSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showMedicalFacilities") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showMedicalFacilities")
    }
    func SupportGroupsSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showSupportGroups") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showSupportGroups")
    }
    func EmploymentAssistanceSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showEmploymentAssistance") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showEmploymentAssistance")
    }
    func TransportationAssistanceSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showTransportationAssistance") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showTransportationAssistance")
    }
    func ShowersSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showShowers") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showShowers")
    }
    func SuicidePreventionSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showSuicidePrevention") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showSuicidePrevention")
    }
    func DomesticViolenceResourcesSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showDomesticViolenceResources") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showDomesticViolenceResources")
    }
    func VeteranServicesSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showVeteranServices") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showVeteranServices")
    }
    func ReferalServicesSwitchFlipped(categorySwitch: UISwitch) {
        let newValue = !(NSUserDefaults.standardUserDefaults().valueForKey("showReferalServices") as! Bool)
        NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "showReferalServices")
    }
}