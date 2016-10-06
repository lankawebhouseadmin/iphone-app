//
//  BE24UserModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/27/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24UserModel: BE24Model {

    var username: String?
    var gender: String?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: NSDate?
    var recentState: String?
    var activity: Bool = true
    var apiKey: String?
    var loginTime: NSDate?
    
    override init(data: JSON) {
        super.init(data: data)
        username    = data["username"].string
        gender      = data["gender"].string
        firstName   = data["firstname"].string
        lastName    = data["lastname"].string
        dateOfBirth = data["date_of_birth"].dateFromFormat()
        recentState = data["recent_state"].string
        activity    = data["active"].boolValue
        apiKey      = data["api_key"].string
        loginTime   = data["login_time"].dateTime()
    }
}
