//
//  UIView+BE24.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeRoundView(radius r : CGFloat = 5.0) -> Void {
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
    
    func makeBorder(_ color: UIColor, borderWidth: CGFloat = 1) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}
