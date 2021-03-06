//
//  Location.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/22/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import CoreLocation

class Location{
  
  class func geocodeAddressString(address:String, completion:(placemark:CLPlacemark?, error:NSError?)->Void){
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
      if error == nil{
        if placemarks?.count > 0{
          completion(placemark: (placemarks?[0]), error: error)
        }
      }
      else{
        completion(placemark: nil, error: error)
      }
    })
  }
  
  class func reverseGeocodeLocation(location:CLLocation,completion:(placemark:CLPlacemark?, error:NSError?)->Void){
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
      if let err = error{
        print("Error Reverse Geocoding Location: \(err.localizedDescription)")
        completion(placemark: nil, error: error)
        return
      }
      completion(placemark: placemarks?[0], error: nil)
      
    })
  }
  
  class func addressFromPlacemark(placemark:CLPlacemark)->String{
    var address = ""
    
    if let name = placemark.addressDictionary?["Name"] as? String {
        address = constructAddressString(address, newString: name)
    }
  
    if let city = placemark.addressDictionary?["City"] as? String {
        address = constructAddressString(address, newString: city)
    }
    
    if let state = placemark.addressDictionary?["State"] as? String {
        address = constructAddressString(address, newString: state)
    }
    
    if let country = placemark.country{
      address = constructAddressString(address, newString: country)
    }
    
    return address
  }
  
  private class func constructAddressString(string:String, newString:String)->String{
    var address = string
    if !address.isEmpty{
      address = address.stringByAppendingString(", \(newString)")
    }
    else{
      address = address.stringByAppendingString(newString)
    }
    return address
  }
}