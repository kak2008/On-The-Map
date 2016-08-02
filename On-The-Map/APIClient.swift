//
//  APIClient.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/31/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import Foundation

class APIClient: NSObject {
    
    
    // MARK: - Login Button Pressed, User Authentication
    
    func checkUdacityLogin(email: String, password: String, failure: (errorMessage: String) -> Void, success: () -> Void) {
        // Create Request
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Send Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Check for error
            if error != nil {
                failure(errorMessage: "")
                //print("login failed with error, \(error?.localizedDescription)")
                
                return
            }
            
            // Parse the data
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            do {
                // Convert the data to JSON
                let json = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                
                // Check for server error
                if(json.valueForKey("status") != nil) {
                    
                    let jsonStatus = json .valueForKey("status") as! NSNumber
                    let errorMessage = json["error"] as! String

                    if (jsonStatus == 403)
                    {
                        failure (errorMessage: errorMessage)
                        return
                    }
                    
                    //TODO: Notify the caller that this is an error
                //    print("login failed with status, \(json["error"])")
                    failure(errorMessage: json["error"] as! String)
                    
                    return
                }
                
                let user = User.sharedInstance
                user.updateUserCredentials(json)
                
                success()
                print("login Sucess!")
            }
            catch {
                
            }

        }
        
        task.resume()
    }
    
    
    
    
    // MARK: - Webservice call for posting user location
    
    func postStudentInformation(failure: (errorMessage: String) -> Void, success: () -> Void)
    {
        // Creating user location manager shared instance object
        let userLocMang = UserLocationManager.locationManagerSharedInstance
       
        // Creating request
        let httpBodyString = "{\"uniqueKey\": \"\(userLocMang.loginUserUniqueKey)\", \"firstName\": \"\(userLocMang.loginUserFirstName)\", \"lastName\": \"\(userLocMang.loginUserLastName)\",\"mapString\": \"\(userLocMang.loginUserMapString)\", \"mediaURL\": \"\(userLocMang.loginUserMediaUrl)\",\"latitude\": \(userLocMang.userEnteredLocationLatitude), \"longitude\":\(userLocMang.userEnteredLocationLongitude)}"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBodyString.dataUsingEncoding(NSUTF8StringEncoding)
      
        // Send Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
          
            // Check for error
            if error != nil
            {
                failure(errorMessage: "")
                return
            }
            
            // Parse the data
            // let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            do {
                // Convert the data to JSON
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
               
                // Check for server error
                if(json.valueForKey("status") != nil) {
                    
                    let jsonStatus = json .valueForKey("status") as! NSNumber
                    let errorMessage = json["error"] as! String
                    
                    if (jsonStatus == 403)
                    {
                        failure (errorMessage: errorMessage)
                        return
                    }
                    //TODO: Notify the caller that this is an error
                    //    print("login failed with status, \(json["error"])")
                    failure(errorMessage: json["error"] as! String)
                    
                    return
                }
                
                success()
                print("Submission Sucess!")
            }
            catch {
                
            }
        }
        task.resume()
    }
    

    // MARK: - Webservice call for logout 
    func LogoutStudentSession(failure: (errorMessage: String) -> Void, success: () -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error
                failure(errorMessage: "")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            do {
                // Convert the data to JSON
                let json = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                
                // Check for server error
                if(json.valueForKey("status") != nil) {
                    
                    let jsonStatus = json .valueForKey("status") as! NSNumber
                    let errorMessage = json["error"] as! String
                    
                    if (jsonStatus == 403)
                    {
                        failure (errorMessage: errorMessage)
                        return
                    }
                    //TODO: Notify the caller that this is an error
                    //    print("login failed with status, \(json["error"])")
                    failure(errorMessage: json["error"] as! String)
                    
                    return
                }
                
                success()
                print("Logout Sucess!")
            }
            catch {
                
            }
        }
        task.resume()
    }
    
}


