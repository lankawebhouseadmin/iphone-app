//
//  BE24Model.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24Model: NSObject {

    var id: Int = 0
    
    init(data: JSON) {
        super.init()
        id = data["id"].intValue
    }
}
