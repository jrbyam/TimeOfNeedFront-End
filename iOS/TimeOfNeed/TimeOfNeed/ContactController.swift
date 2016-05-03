//
//  ContactController.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 4/23/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import MessageUI

class ContactController : UIViewController, MFMailComposeViewControllerDelegate {

    @IBAction func contact(sender: AnyObject) {
        let subjectPrefix = "[Time of Need Organization Information]"
        let recepient = ["mecourter@alaska.edu"]
        let mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(recepient)
        mailer.setSubject(subjectPrefix)
        presentViewController(mailer, animated: true, completion: nil)
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
