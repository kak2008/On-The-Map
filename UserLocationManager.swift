//
//  UserLocationManager.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/13/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class UserLocationManager: NSObject
{
    static let locationManagerSharedInstance = UserLocationManager()
    
    var loginUserUniqueKey: String!
    var loginUserFirstName: String!
    var loginUserLastName: String!
    var loginUserMapString: String!
    var loginUserMediaUrl: String!
    
    var userEnteredLocationLatitude: Double!
    var userEnteredLocationLongitude: Double!
    
    var userEnteredUdacityEmailID: String!
    var userEnteredUdacityPassword: String!

    
    // MARK: - Webservice call for Users Location Details
    /** Brings students locations from webservice */
    func getUserLocations(failure: (errorMessage: String) -> Void, success: () -> Void)
    {
     
        let BASE_URL = "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt"
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
           
            
            if error != nil
            { // Handle error...
                failure(errorMessage: "")
                
                return
            }
            //      print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            do
            {
                // Convert the data to JSON
                let jsonDetails = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary

                
                
                // Check for server error
                if(jsonDetails.valueForKey("error") != nil) {
                    let errorMsg = jsonDetails["error"] as! String
                    failure(errorMessage: errorMsg)
                    
                    return
                }
                
                let userDetailsArray = jsonDetails["results"] as! NSArray
                let userObject = User.sharedInstance
                userObject.userJsonDetailsArray = userDetailsArray
                success()
                print("Reloading completed")
            }
            catch
            {
            }
        }
        task.resume()
        
    }
    
 

    // MARK: - Webservice call for getting user details
    /** Fetches Login User Details*/
    func getLoginUserDetails()
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(loginUserUniqueKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil
            {
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
       //     print("data:\(NSString(data: newData, encoding: NSUTF8StringEncoding))")
            
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            let userData = jsonData.valueForKey("user")
            self.loginUserFirstName = userData! .valueForKey("first_name") as! String!
            self.loginUserLastName = userData! .valueForKey("last_name") as! String!
            }
            catch {
            }
        }
        task.resume()
    }
    
    func hardProcessingWithString(input: String, completion: (result: String) -> Void)
    {
        completion(result: "we finished!")
    }

}
    

