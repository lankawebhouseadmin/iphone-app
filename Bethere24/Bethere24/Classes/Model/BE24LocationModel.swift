//
//  BE24LocationModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24LocationModel: BE24Model {

    /// API result fields
    var personID        : Int!
    var locationType    : String!
    var address         : String?
    var city            : String?
    var state           : BE24StateGroupModel!
    var alert           : [BE24AlertModel]?
    var clientInfo      : BE24ClientInfoModel!
    

    override init(data: JSON) {
        super.init(data: data)
        personID        = data["person"].intValue
        locationType    = data["location_type"].stringValue
        address         = data["address"].string
        city            = data["city"].string
        clientInfo      = BE24ClientInfoModel(data: data["client_info"])
//        zipCode         = data["zip"].string
//        country         = data["country"].string
//        virtualDayStartOrigin = data["virtual_day_start"].stringValue
//        if let virtualDay = DATE_FORMATTER.OnlyTime.dateFromString(virtualDayStartOrigin!) {
//            virtualDayStart = DATE_FORMATTER.TimeA.stringFromDate(virtualDay)
//        }
        state           = BE24StateGroupModel(data: data["state"], virtualTime: clientInfo.virtualDayStartOriginal)
        alert = []
        data["alert"].arrayValue.forEach { (elem: JSON) in
            self.alert?.append(BE24AlertModel(data: elem))
        }
        
        branchState()
    }
    
    fileprivate func branchState() -> Void {
        
    }
}
