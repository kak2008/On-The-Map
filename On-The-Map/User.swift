//
//  User.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/10/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class User: NSObject
{
    var userEmailID: String!
    var accountKey: String!
    var sessionID: String!
    var sessionExpiration: String!
    
    static let sharedInstance = User()
    
    var userJsonDetailsArray: NSArray! 
    
    func updateUserCredentials(userJsonResponse: NSDictionary)
    {
        let accountJson = userJsonResponse["account"] as! NSDictionary
        accountKey = accountJson["key"] as! String
        
        let userLMObj = UserLocationManager.locationManagerSharedInstance
        userLMObj.loginUserUniqueKey = accountKey
        
        let sessionJson = userJsonResponse["session"] as! NSDictionary
        sessionID = sessionJson["id"] as! String
        sessionExpiration = sessionJson["expiration"] as! String
        
    }
    
    
    
}
