//
//  BE24AppManager.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24AppManager: NSObject {

    class var sharedManager: BE24AppManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BE24AppManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BE24AppManager()
        }
        return Static.instance!
    }

}

let kMenuIconKeyName        = "icon"
let kMenuTitleKeyName       = "name"