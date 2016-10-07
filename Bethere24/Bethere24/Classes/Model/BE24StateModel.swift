//
//  BE24StateModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24StateModel: BE24Model {

    var stateType       : Int!
    var personLocation  : Int!
    var sensor          : Int!
    var startTime       : NSDate!
    var endTime         : NSDate!
    var score           : Int!
    var normalTime      : Int!
    var actualTime      : Int!
    
    override init(data: JSON) {
        super.init(data: data)
        stateType       = data["state_type"].intValue
        personLocation  = data["person_location"].intValue
        sensor          = data["sensor"].intValue
        startTime       = NSDate(timeIntervalSince1970: data["start_time"].doubleValue)
        endTime         = NSDate(timeIntervalSince1970: data["end_time"].doubleValue)
        score           = data["score"].intValue
        normalTime      = data["normal_time"].intValue
        actualTime      = data["actual_time"].intValue
        
    }
    
    func dateString() -> String {
        return DATE_FORMATTER.Default.stringFromDate(startTime!)
    }
    
    func type() -> HealthType {
        switch stateType {
        case 1, 8:
            return .InBedroom
        case 2:
            return .InRecliner
        case 7:
            return .InBathroom
        case 5:
            return .InDining
        case 9:
            return .InMotion
        case 10:
            return .TakingMedication
        case 11:
            return .AwayFromHome
        case 12:
            return .WithVisitors
        default:
            return .Other
        }
    }
}

