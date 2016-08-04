//
//  UserInfo.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/31/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import Foundation

struct UserInfo
{
    var userEmailID: String!
    var accountKey: String!
    var sessionID: String!
    var sessionExpiration: String!
    
    init() {
        
    }
    
    init (email: String, json: NSDictionary) {
        let accountJson = json["account"] as! NSDictionary
        let sessionJson = json["session"] as! NSDictionary
        
        userEmailID = email;
        accountKey = accountJson["key"] as! String
        sessionID = sessionJson["id"] as! String
        sessionExpiration = sessionJson["expiration"] as! String
    }
}