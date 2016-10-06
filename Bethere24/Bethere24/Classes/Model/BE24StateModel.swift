//
//  BE24StateModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24StateGroupModel: BE24Model {
    
    var medication      : [BE24StateModel]?
    var inRecliner      : [BE24StateModel]?
    var inDining        : [BE24StateModel]?
    var inBedroom       : [BE24StateModel]?
    var withVisitors    : [BE24StateModel]?
    var inBathroom      : [BE24StateModel]?
    var inMotion        : [BE24StateModel]?
    var awayFromHome    : [BE24StateModel]?
    
    override init(data: JSON) {
        super.init(data: data)
        if let states = data["medication"].array {
            medication = []
            states.forEach({ (elem: JSON) in
                medication!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["in_recliner"].array {
            inRecliner = []
            states.forEach({ (elem: JSON) in
                inRecliner!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["in_dining"].array {
            inDining = []
            states.forEach({ (elem: JSON) in
                inDining!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["sleeping"].array {
            inBedroom = []
            states.forEach({ (elem: JSON) in
                inBedroom!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["in_bathroom"].array {
            inBathroom = []
            states.forEach({ (elem: JSON) in
                inBathroom!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["away_from_home"].array {
            awayFromHome = []
            states.forEach({ (elem: JSON) in
                awayFromHome!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["with_visitors"].array {
            withVisitors = []
            states.forEach({ (elem: JSON) in
                inRecliner!.append(BE24StateModel(data: elem))
            })
        }
        if let states = data["in_motion"].array {
            inMotion = []
            states.forEach({ (elem: JSON) in
                inMotion!.append(BE24StateModel(data: elem))
            })
        }
    }
    
}


class BE24StateModel: BE24Model {

    var stateType       : Int!
    var personLocation  : Int!
    var sensor          : Int!
    var startTime       : NSDate?
    var endTime         : NSDate?
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
    
}

