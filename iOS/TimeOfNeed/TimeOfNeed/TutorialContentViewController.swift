//
//  TutorialImageViewController.swift
//  TimeOfNeed
//
//  Created by Lonny Strunk on 4/25/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var continueToApp: UIButton!
    @IBAction func continueToApp(sender: UIButton) {
        self.performSegueWithIdentifier("backToMain", sender:self)
    }
    
    var hideButton: Bool = true
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = tutorialImage {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    var instructionText: String = "" {
        didSet {
            if let label = instruction {
                label.text = instructionText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialImage!.image = UIImage(named: imageName)
        instruction!.text = instructionText
        continueToApp.hidden = hideButton
    }
}
