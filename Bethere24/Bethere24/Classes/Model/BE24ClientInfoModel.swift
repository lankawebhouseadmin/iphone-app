//
//  BE24ClientInfoModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 1/19/17.
//  Copyright © 2017 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24ClientInfoModel: BE24Model {

    var username: String
    var firstName: String
    var lastName: String
    var gender: String
    var timeZone: String
    var currentTime: Date
    var currentTimeString: String
    var virtualDayStart: String
    var virtualDayStartOriginal: String
    var dateOfBirth: String
    var country: String
    var zipcode: String
    var timezoneDouble: Double = 0
    
    override init(data: JSON) {
        username    = data["username"].stringValue
        firstName   = data["firstname"].stringValue
        lastName    = data["lastname"].stringValue
        gender      = data["gender"].stringValue
        timeZone    = data["time_zone"].stringValue
       
        
        currentTimeString = data["current_time"].stringValue
        if let _currentTime = data["current_time"].dateTime() {
            currentTime = _currentTime
        } else {
            currentTime = Date()
        }
        virtualDayStartOriginal = data["virtual_day_start"].stringValue
        dateOfBirth = data["date_of_birth"].stringValue
        country     = data["country"].stringValue
        zipcode     = data["zip"].stringValue
        if let virtualDay = DATE_FORMATTER.OnlyTime.date(from: virtualDayStartOriginal) {
            virtualDayStart = DATE_FORMATTER.TimeA.string(from: virtualDay)
        } else {
            virtualDayStart = DATE_FORMATTER.TimeA.string(from: Date())
        }

        super.init(data: data)
        
        for key in NSTimeZone.abbreviationDictionary.keys {
            if let val = NSTimeZone.abbreviationDictionary[key] {
                if val == timeZone {
                    timezoneDouble = Double((NSTimeZone.init(abbreviation: key)?.secondsFromGMT)!)
                    //                    print(test)
                }
            }
        }
    }
    
    func currentTimeDayString() -> String {
        let virtualElems = virtualDayStartOriginal.components(separatedBy: ":")
        let virtualSeconds = Double(virtualElems[0])! * 3600 + Double(virtualElems[1])! * 60 + Double(virtualElems[2])!
        let virtualCurrentime = Date(timeIntervalSince1970: (currentTime.timeIntervalSince1970 - virtualSeconds))
        return DATE_FORMATTER.Default.string(from: virtualCurrentime)
    }
    
    func getFormattedVirtualDayStartTime() -> String {
        if let startTime = DATE_FORMATTER.OnlyTime.date(from: virtualDayStartOriginal) {
            return DATE_FORMATTER.TimeA.string(from: startTime)
        } else {
            return virtualDayStartOriginal
        }
    }
}
