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
    
    @IBOutlet weak var continueToApp: UIButton!
    @IBAction func continueToApp(sender: UIButton) {
        self.performSegueWithIdentifier("backToMain", sender:self)
    }
    
    // MARK: - Variables
    var hideButton: Bool = true
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = tutorialImage {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialImage!.image = UIImage(named: imageName)
        continueToApp.hidden = hideButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
