//
//  MapViewController.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/4/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{

    var udacityUsersLocationDetailsArray: NSArray!

    @IBOutlet weak var mapViewer: MKMapView!
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        getUserDetails()
        mapViewer.delegate = self
    }
 
    // MARK: - User Details Webservice call 
  
    func getUserDetails()
    {
        let getUserLoc = UserLocationManager()
        getUserLoc.getUserLocations {
            self.dropPinAnnotation()
        }
    }
    
    // MARK: - Alert Methods
    
    // Alert Message with Ok Action
    func createAlertWithMessage(title: String, message: String)
    {
        let UIAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        UIAlert.addAction(UIAlertAction(title: "ok",style: .Default, handler: {(ACTION:UIAlertAction!) in }))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(UIAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Drop Pin MAP Annotations Actions
    
    // Annotation
    func dropPinAnnotation()
    {
        if let items = User.sharedInstance.userJsonDetailsArray
        {
            for item in items
            {
                let lat = item.valueForKey("latitude") as! Double
                let long = item.valueForKey("longitude")as! Double
                
                let newLocation = CLLocationCoordinate2DMake(lat, long)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = newLocation
               
                let userFirstName = item.valueForKey("firstName") as? String
                let userLastName = item.valueForKey("lastName") as? String
                dropPin.title = "\(userFirstName!) \(userLastName!)"
                dropPin.subtitle = item.valueForKey("mediaURL") as? String
                
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.mapViewer.addAnnotation(dropPin)
                })
            }
        }
    }
    
    // Annotation Detail Accessory
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let mkPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinDrop")
        
        mkPinView.canShowCallout = true
        let pinDetailButton = UIButton(type: .DetailDisclosure)
        mkPinView.rightCalloutAccessoryView = pinDetailButton
        
        return mkPinView
    }
    
    
    // Accessory Tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        
        let receivedURL = (view.annotation?.subtitle!)!
        
        if let url = NSURL(string: receivedURL)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Logout Button Pressed Actions
    @IBAction func LogoutButtonPressed(sender: AnyObject)
    {
        let api = APIClient()
        
        api.LogoutStudentSession({ (errorMessage) in
            // failure case
            var message = errorMessage
            if message == "" {
                message = "We are not able to process the request, please try again later."
            }
            
            self.createAlertWithMessage("Logout Failed", message: message)
            }) { 
               // success case
              dispatch_async(dispatch_get_main_queue(), { 
                self.dismissViewControllerAnimated(true, completion: nil)
              })
        }
    }

    @IBAction func refreshButtonPressed(sender: AnyObject)
    {
        mapViewer.removeAnnotations(mapViewer.annotations)
        getUserDetails()
    }
    
    
    // MARK: - Pin Button Pressed Actions
    
    @IBAction func pinBarButtonIsPressed(sender: AnyObject)
    {
        performSegueWithIdentifier("mapViewToInfoViewSegueID", sender: nil)
    }
    

}
