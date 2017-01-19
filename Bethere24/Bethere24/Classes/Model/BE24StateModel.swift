//
//  BE24StateModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 BeThere24. All rights reserved.
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
    
    private var virtualTime: String = "00:00:00"
    var virtualStartTime: NSDate!
    var virtualEndTime: NSDate!
    
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
        
        virtualStartTime = startTime
        virtualEndTime   = endTime
    }
    
    func setVirtualDayTime(virtualTime: String) -> Void {
        self.virtualTime = virtualTime
        
        let virtualElems = virtualTime.componentsSeparatedByString(":")
        let virtualSeconds = Double(virtualElems[0])! * 3600 + Double(virtualElems[1])! * 60 + Double(virtualElems[2])!
        
        virtualStartTime = NSDate(timeIntervalSince1970: (startTime.timeIntervalSince1970 - virtualSeconds))
        virtualEndTime   = NSDate(timeIntervalSince1970: (endTime.timeIntervalSince1970 - virtualSeconds))
    }
    
    func dateString(virtualTime: String) -> String {
        
        return DATE_FORMATTER.Default.stringFromDate(virtualStartTime)
        
        /*
        let timeString = DATE_FORMATTER.OnlyTime.stringFromDate(startTime)
        let elems = timeString.componentsSeparatedByString(":")
        let timeSeconds = Int(elems[0])! * 3600 + Int(elems[1])! * 60 + Int(elems[2])!
        let virtualElems = virtualTime.componentsSeparatedByString(":")
        let virtualSeconds = Int(virtualElems[0])! * 3600 + Int(virtualElems[1])! * 60 + Int(virtualElems[2])!
        if timeSeconds > virtualSeconds {
            return DATE_FORMATTER.Default.stringFromDate(startTime)
        } else {
            return DATE_FORMATTER.Default.stringFromDate(NSDate(timeIntervalSince1970: startTime.timeIntervalSince1970 - Double(virtualSeconds)))
        } */
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

