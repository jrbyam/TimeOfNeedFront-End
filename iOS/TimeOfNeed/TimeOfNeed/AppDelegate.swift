//
//  AppDelegate.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/4/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Spawn a thread with HIGH priority to do the initial content checking and updating.
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // Check for network connection
            reachability.startNotifier();
            netStatus = reachability.currentReachabilityStatus();
            networkConnected = netStatus.rawValue != NOTREACHABLE
            while !networkConnected {
                // Wait until a network connection is made or old data is confirmed as present
                if displayOldData {
                    break
                }
            }
            self.updateContent()
        }
        
        // Set up initial ViewController variables
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController
        var navigationController: UINavigationController
        
        // If first time opening the app
        if(NSUserDefaults.standardUserDefaults().boolForKey("firstOpened") == false) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstOpened")
            
            initialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TutorialPageViewController") as! TutorialPageViewController
            self.window?.rootViewController = initialViewController
            
        }
        else
        {
            initialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            navigationController = mainStoryboard.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
            self.window?.rootViewController = navigationController
        }
        
        self.window?.makeKeyAndVisible()
        
        return true;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
/*
    Helper and Content Functions
*/
    // updateContent
    func updateContent() {
        let locationsPath = "http://ton.cs.uaf.edu/api/getlocations"
        let versionPath = "http://ton.cs.uaf.edu/api/getdataversion"
        
        if NSUserDefaults.standardUserDefaults().objectForKey("serviceData") != nil { // There has been data previously stored.
            let oldVersion = (NSUserDefaults.standardUserDefaults().objectForKey("currentVersion") as! NSInteger)
            let currentVersion = loadVersion(versionPath);
            
            // If the current version is less than the new one, an update is needed.
            if  oldVersion < currentVersion {
                if displayOldData { // Set in the checkNetwork function in MainViewController.swift
                    print("Displaying old content")
                } else {
                    print("Updating stored data...")
                    loadDataFromJson(locationsPath)
                }
            } else {
                print("Data is current or could not retrieve version.")
            }
        } else { // There is no previously stored data.
            print("Retrieving data for first time...")
            loadVersion(versionPath)
            loadDataFromJson(locationsPath)
        }
        
        // If this is the first time retreiving data (there is none already present) but the server could not be connected to,
        // there is nothing further to be done.  cannotContinue is set to true here and handled in ViewController.swift.
        if !connectedToServer && NSUserDefaults.standardUserDefaults().objectForKey("serviceData") == nil {
            cannotContinue = true
            return
        }
        
        // The global dictionary responsable for holding the data is set here from the archived data to be used
        // throughout the application for the remainder of the instance of the application.
        serviceData = NSUserDefaults.standardUserDefaults().valueForKey("serviceData") as! Array<NSMutableDictionary>
        
        // Add coordinates for each based on address
        for location in serviceData {
            servicesCoordinates.append(CLLocationCoordinate2D()) // Include a placeholder
            if location["address_line1"] != nil && (location["address_line1"] as! NSString).substringToIndex(4) != "P.O." {
                let address = (location["address_line1"] as! String) + ", " + (location["address_line3"] as! String)
                CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if (error) != nil {
                        print("Error", error)
                    }
                    if let placemark = placemarks?.first {
                        servicesCoordinates[serviceData.indexOf(location)!] = placemark.location!.coordinate
                    }
                })
            }
        }
    }
    // loadDataFromJson
    // This function establishes a connection with the VM, loads the content into a dictionary and saves data from that dictionary into storage.
    // If a connection cannot be made, it simply sets connectionToServer to false.
    func loadDataFromJson(filePath: String) {
        var data: NSData?
        do {
            data = try NSData(contentsOfURL: NSURL(string: filePath)!, options: NSDataReadingOptions.DataReadingUncached)
        } catch {
            print(error)
        }
        if (data == nil) {
            print("Error: Could not update data because the downloaded json data was nil")
            connectedToServer = false
            return
        }
        let jsonDict: NSMutableDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableDictionary
        // Load data into persistant storage
        serviceData = (jsonDict["locations"] as! Array<NSMutableDictionary>)
        NSUserDefaults.standardUserDefaults().setObject(serviceData, forKey: "serviceData")
    }
    // loadVersion
    func loadVersion(filePath: String) -> NSInteger {
        var data : NSData?
        var currentVersion : NSInteger = 0
        do {
            data = try NSData(contentsOfURL: NSURL(string: filePath)!, options: NSDataReadingOptions.DataReadingUncached)
        } catch {
            print(error)
        }
        if (data == nil) {
            print("Error: Could not update data because the downloaded json data was nil")
            connectedToServer = false
            return 0;
        }
        data!.getBytes(&currentVersion, length: sizeof(NSInteger))
        NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "currentVersion")
        return currentVersion
    }
    // getFileUrl
    // This function retrieves a valid url from the document directory.
    func getFileUrl(fileName: String) -> NSURL {
        let manager = NSFileManager.defaultManager()
        let dirURL = try? manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        return dirURL!.URLByAppendingPathComponent(fileName)
    }

}

