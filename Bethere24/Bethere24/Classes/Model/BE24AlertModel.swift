//
//  BE24AlertModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24AlertModel: BE24Model {

    var alertType  : String!
    var normalTime : Int!
    var actualTime : Int!
    var stateType  : Int!
    var score      : Int!
    var alertTime  : Date!
    
    override init(data: JSON) {
        super.init(data: data)
        alertType  = data["alert_type"].stringValue
        normalTime = data["normal_time"].intValue
        actualTime = data["actual_time"].intValue
        stateType  = data["state_type"].intValue
        score      = data["score"].intValue
        alertTime  = Date(timeIntervalSince1970: data["alert_time"].doubleValue)
    }
    
    func dateString(_ virtualTime: String) -> String {
        let virtualElems = virtualTime.components(separatedBy: ":")
        let virtualSeconds = Double(virtualElems[0])! * 3600 + Double(virtualElems[1])! * 60 + Double(virtualElems[2])!
        
        let virtualTime = Date(timeIntervalSince1970: (alertTime.timeIntervalSince1970 - virtualSeconds))

        return DATE_FORMATTER.Default.string(from: virtualTime)
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
