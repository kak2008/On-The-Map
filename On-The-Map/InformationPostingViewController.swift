//
//  InformationPostingViewController.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/12/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController {

    
    @IBOutlet weak var infoMapViewer: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userEnteredLocation: UITextField!
    @IBOutlet weak var findOnAMapButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var selectedTextField: UITextField!
    var locationCoordinate: CLLocationCoordinate2D!
    var errorOccured: Bool = false

    let userLocMang = UserLocationManager.locationManagerSharedInstance
    
    // MARK: - Life Cycle Methods
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hideUIElements(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        view.endEditing(true) // KeyBoard will disappear when user Tap on view
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        unsubsribeToKeyboardNotification()
    }
    

    // MARK: - Hide/Unhide UI Elements
    
    // hide Map, TextField and Submit Button
    func hideUIElements(GivenValue: Bool)
    {
        infoMapViewer.hidden = GivenValue
        linkTextField.hidden = GivenValue
        submitButton.hidden = GivenValue
    }
    
    // Unhide TextFields and Find Location Button
    func activeUISecondSetElements(givenValue: Bool)
    {
        userEnteredLocation.hidden = givenValue
        findOnAMapButton.hidden = givenValue
        textLabel.hidden = givenValue
    }

    
    // MARK: - Webservice call for posting user location
    
    func postStudentInformation()
    {
        let httpBodyString = "{\"uniqueKey\": \"\(userLocMang.loginUserUniqueKey)\", \"firstName\": \"\(userLocMang.loginUserFirstName)\", \"lastName\": \"\(userLocMang.loginUserLastName)\",\"mapString\": \"\(userLocMang.loginUserMapString)\", \"mediaURL\": \"\(userLocMang.loginUserMediaUrl)\",\"latitude\": \(userLocMang.userEnteredLocationLatitude), \"longitude\":\(userLocMang.userEnteredLocationLongitude)}"
        print(httpBodyString)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBodyString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil
            {
                self.createAlertWithMessage("Network Error", message: "We are not able to process the request, please try again later.")
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
         //   print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    
    // MARK: - Alert Action
    
    func createAlertWithMessage(title: String, message: String)
    {
        let UIAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        UIAlert.addAction(UIAlertAction(title: "ok",style: .Default, handler: {(ACTION:UIAlertAction!) in }))
        presentViewController(UIAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - Create Annotation for User Location
    
    func createMapAnnotation()
    {
        // create Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate;
        infoMapViewer.addAnnotation(annotation)
        
        // zoom to annotaion
        infoMapViewer.centerCoordinate = locationCoordinate
    }

    
    // MARK: - Submit Button Pressed Actions

    @IBAction func submitButtonIsPressed(sender: AnyObject)
    {
        // update URL address
        self.userLocMang.loginUserMediaUrl = linkTextField.text!
        
        // create alert if link is nil
        if(linkTextField.text == "")
        {
            createAlertWithMessage("Error", message: "Please provide the link...!")
        }
        else
        {
            //post user information
            postStudentInformation()
        }
    }
    
    
    // MARK: - Cancel Button Pressed Actions

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // MARK: - Find My Location Button Pressed Actions
    
    @IBAction func findOnAMapButtonPressed(sender: AnyObject)
    {
        hideUIElements(false)
        captureGeoLocation()
    }
    
    func captureGeoLocation()
    {
        let userEnteredAddress = self.userEnteredLocation
        self.userLocMang.loginUserMapString = userEnteredAddress.text!
        let geoCode = CLGeocoder()
//        print(userEnteredAddress.text!)
        
        geoCode.geocodeAddressString((userEnteredAddress.text!), completionHandler: { (placemark, error) in
            if (error != nil)
            {
                self.errorOccured = true
                self.createAlertWithMessage("Error Location", message: "Could not find the location, Try Again..!")
                self.hideUIElements(true)
            }
            if let placemark = placemark?.first
            {
                self.activeUISecondSetElements(true)
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.locationCoordinate = coordinates
                self.createMapAnnotation()

                self.userLocMang.userEnteredLocationLatitude = coordinates.latitude
                self.userLocMang.userEnteredLocationLongitude = coordinates.longitude
            }
        })
    }
    
    
    // MARK: - KeyBoard Resigning and Notification
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        selectedTextField = textField
    }
    
    // Calculation of keyBoard Height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Move frame upward
    func keyboardWillShow(notification: NSNotification)
    {
        if ((selectedTextField != nil && (selectedTextField == userEnteredLocation || selectedTextField == linkTextField)) && self.view.frame.origin.y == 0.0)
        {
            let keyBoardTop = view.frame.height - getKeyboardHeight(notification)
            let diffADD = (keyBoardTop - selectedTextField.frame.maxY)
            if (keyBoardTop - selectedTextField.frame.maxY) < 40
            {
                self.view.frame.origin.y -= (40-diffADD)
            }
        }
    }
    
    // Move frame back to its original position
    func keyboardWillHide(notification: NSNotification)
    {
        if -self.view.frame.origin.y > 0
        {
            self.view.frame.origin.y = 0
        }
    }
    
    //Suscribe the view controller to the UIKeyboardWillShowNotification:
    func subscribeToKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe the view controller to the UIKeyboardWillShowNotification:
    func unsubsribeToKeyboardNotification()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}
