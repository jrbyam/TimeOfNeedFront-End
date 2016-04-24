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
    
}
