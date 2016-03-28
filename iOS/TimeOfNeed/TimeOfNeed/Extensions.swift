//
//  Extensions.swift
//  TimeOfNeed
//
//  Created by Jay Byam on 3/26/16.
//  Copyright © 2016 TON. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    func distanceInMetersFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
        let firstLoc = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let secondLoc = CLLocation(latitude: otherCoord.latitude, longitude: otherCoord.longitude)
        return firstLoc.distanceFromLocation(secondLoc)
    }
    
}