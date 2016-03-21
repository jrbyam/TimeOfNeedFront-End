//
//  ServiceSelectionView.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 3/21/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit

class ServiceSelectionView: UIView {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            // On a touch, save the name of the category that was selected to be accessed when displaying the services
            serviceSelected = (self.viewWithTag(self.tag + 1) as! UILabel).text!
        }
        super.touchesBegan(touches, withEvent:event)
    }
}
