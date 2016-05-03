//
//  TutorialPageViewController.swift
//  TimeOfNeed
//
//  Created by Lonny Strunk on 4/19/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let tutorialImages = [ "main", "quickClose", "search", "settings", "startLocation" ]
    let instructions = [ "Select a service to view locations near you.",
                         "Press the exit icon to exit the app quickly.",
                         "Press the search icon to search locations by name.",
                         "Press the settings icon to customize main menu and set start location.",
                         "If you don't allow access to your current location, set your start location in settings." ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        let startingViewController = getItemController(0)! as TutorialContentViewController
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutorialContentViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutorialContentViewController
        
        if itemController.itemIndex+1 < tutorialImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> TutorialContentViewController? {
        
        if itemIndex < tutorialImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("TutorialContentViewController") as! TutorialContentViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = tutorialImages[itemIndex]
            pageItemController.instructionText = instructions[itemIndex]
            if (itemIndex == (tutorialImages.count - 1))
            {
                pageItemController.hideButton = false;
            } else {
                pageItemController.hideButton = true;
            }
            
            return pageItemController
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tutorialImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
