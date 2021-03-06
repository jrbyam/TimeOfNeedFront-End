//
//  StartLocationViewController.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/21/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import MapKit
import CoreLocation

class StartLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
// Added by Jay Byam ////////////////////////////////////////////////////////////
    @IBAction func setStart(sender: AnyObject) {
        CLGeocoder().geocodeAddressString(autocompleteTextfield.text!, completionHandler: {(placemarks, error) -> Void in
            if (error) != nil {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                startingCoordinates = placemark.location!.coordinate
                let storableCoordinates : Dictionary<String, NSNumber> = [ "latitude" : (startingCoordinates.latitude as NSNumber), "longitude" : (startingCoordinates.longitude as NSNumber) ]
                NSUserDefaults.standardUserDefaults().setObject(storableCoordinates, forKey: "startingCoordinates")
                NSUserDefaults.standardUserDefaults().setValue(self.autocompleteTextfield.text!, forKey: "startingAddress")
            }
        })
        currentStart.text = autocompleteTextfield.text!
    }
    @IBOutlet var currentStart: UILabel!
/////////////////////////////////////////////////////////////////////////////////
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var dataTask:NSURLSessionDataTask?
    
    private let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextField()
        handleTextFieldInterfaces()
// Added by Jay Byam ////////////////////////////////////////////////////////////
        if NSUserDefaults.standardUserDefaults().objectForKey("startingAddress") != nil {
            currentStart.text = NSUserDefaults.standardUserDefaults().objectForKey("startingAddress") as? String
        }
/////////////////////////////////////////////////////////////////////////////////

    }
    
// Added by Jay Byam ////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text)
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if let coordinate = placemark?.location?.coordinate {
                    self?.addAnnotation(coordinate, address: text)
                    self?.mapView.setCenterCoordinate(coordinate, zoomLevel: 12, animated: true)
                }
            })
        }
    }

    //MARK: - Private Methods
    private func addAnnotation(coordinate:CLLocationCoordinate2D, address:String?){
        if let annotation = selectedPointAnnotation{
            mapView.removeAnnotation(annotation)
        }
        
        selectedPointAnnotation = MKPointAnnotation()
        selectedPointAnnotation!.coordinate = coordinate
        selectedPointAnnotation!.title = address
        mapView.addAnnotation(selectedPointAnnotation!)
    }
    
    private func fetchAutocompletePlaces(keyword:String) {
        let urlString = "\(baseURLString)?key=\(googleMapsKey)&input=\(keyword)"
        let s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        s.addCharactersInString("+&")
        if let encodedString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(s) {
            if let url = NSURL(string: encodedString) {
                let request = NSURLRequest(URL: url)
                dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do {
                            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        var locations = [String]()
                                        for dict in predictions as! [NSDictionary]{
                                            locations.append(dict["description"] as! String)
                                        }
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.autocompleteTextfield.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.autocompleteTextfield.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }
    
// Added by Jay Byam ////////////////////////////////////////////////////////////
/*
     Tool Bar Functions:
*/
    func search() {
        performSegueWithIdentifier("search", sender: nil)
    }
    
    func quickKill() {
        exit(0) // Sweet and simple
    }
/////////////////////////////////////////////////////////////////////////////////
}


