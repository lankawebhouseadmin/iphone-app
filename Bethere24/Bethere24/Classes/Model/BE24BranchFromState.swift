//
//  BE24BranchFromState.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/7/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24BranchFromState: NSObject {

    var days: [String] = []
    var statesByDay: [String: AnyObject] = [:]
    var statesByType: [HealthType: AnyObject] = [:]
    
    init(state: BE24LocationModel) {
        super.init()
        
    }
}
