//
//  UIButton+BE24.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

extension UIButton {
    func setEnable(enable: Bool = true) -> Void {
        enabled = enable
        if enable == true {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
