//
//  UIButton+BE24.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

extension UIButton {
    func setEnable(_ enable: Bool = true) -> Void {
        isEnabled = enable
        if enable == true {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
