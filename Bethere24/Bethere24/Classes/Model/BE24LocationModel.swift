//
//  BE24LocationModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/6/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
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
    var zipCode         : String?
    var country         : String?
    var virtualDayStart : String?
    var alert           : [BE24AlertModel]?
    

    override init(data: JSON) {
        super.init(data: data)
        personID        = data["person"].intValue
        locationType    = data["location_type"].stringValue
        address         = data["address"].string
        city            = data["city"].string
        state           = BE24StateGroupModel(data: data["state"])
        zipCode         = data["zip"].string
        country         = data["country"].string
        virtualDayStart = data["virtual_day_start"].string
        alert = []
        data["alert"].arrayValue.forEach { (elem: JSON) in
            self.alert?.append(BE24AlertModel(data: elem))
        }
        
        branchState()
    }
    
    private func branchState() -> Void {
        
    }
}
