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
    static let sharedInstance = User()
    
    var userStruct = UserInfo()

    var userJsonDetailsArray: NSArray!
}
