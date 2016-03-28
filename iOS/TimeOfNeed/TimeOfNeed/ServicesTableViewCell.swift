//
//  ServicesTableViewCell.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 2/15/16.
//  Copyright © 2016 TON. All rights reserved.
//

import UIKit
import MapKit

class ServicesTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hoursTimes: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var moreArrow: UIImageView!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var website: UILabel!
    @IBOutlet var mapView: MKMapView!
    class var expandedHeight: CGFloat { get { return 300 } }
    class var quickLookHeight: CGFloat { get { return 100 } }
    class var defaultHeight: CGFloat { get { return 60 } }
    var observerAdded : Bool = false;
    
    func checkHeight() {
        // Set hidden status of quick look elements
        hoursLabel.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        hoursTimes.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        phoneLabel.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        phoneNumber.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        moreArrow.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        background.hidden = frame.size.height < ServicesTableViewCell.quickLookHeight
        // Set hidden status of extra info view
        extraInfoView.hidden = frame.size.height < ServicesTableViewCell.expandedHeight
    }
    
    func watchFrameChanges() {
        if !observerAdded {
            observerAdded = true
            addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        }
        checkHeight()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
}
