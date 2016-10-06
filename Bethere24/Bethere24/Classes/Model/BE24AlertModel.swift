//
//  BE24AlertModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24AlertModel: BE24Model {

    var alertType  : String!
    var normalTime : Int!
    var actualTime : Int!
    var stateType  : Int!
    var score      : Int!
    var alertTime  : NSDate!
    
    override init(data: JSON) {
        super.init(data: data)
        alertType  = data["alert_type"].stringValue
        normalTime = data["normal_time"].intValue
        actualTime = data["actual_time"].intValue
        stateType  = data["state_type"].intValue
        score      = data["score"].intValue
        alertTime  = NSDate(timeIntervalSince1970: data["alert_time"].doubleValue)
    }
}
