//
//  TutorialPageViewController.swift
//  TimeOfNeed
//
//  Created by Lonny Strunk on 4/19/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var tutorialImages = ["tutorial1","tutorial2"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        let startingViewController = getItemController(0)! as TutorialContentViewController //the first image
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
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
            
            if(itemIndex == (tutorialImages.count - 1))
            {
                pageItemController.hideButton = false;
            } else {
                pageItemController.hideButton = true;
            }
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tutorialImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
