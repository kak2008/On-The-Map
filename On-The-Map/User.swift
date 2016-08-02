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
    var userStruct = UserInfo()
    
    
    static let sharedInstance = User()
    
    var userJsonDetailsArray: NSArray! 
    
    func updateUserCredentials(userJsonResponse: NSDictionary)
    {
        let accountJson = userJsonResponse["account"] as! NSDictionary
        userStruct.accountKey = accountJson["key"] as! String
        
        let userLMObj = UserLocationManager.locationManagerSharedInstance
        userLMObj.loginUserUniqueKey = userStruct.accountKey
        
        let sessionJson = userJsonResponse["session"] as! NSDictionary
        userStruct.sessionID = sessionJson["id"] as! String
        userStruct.sessionExpiration = sessionJson["expiration"] as! String
        
    }
    
    
    
}
