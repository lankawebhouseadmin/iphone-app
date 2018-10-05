//
//  UITextField+BE24.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding : CGFloat = 10.0) -> Void {
        let viewLeftPadding : UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding, height: (frame.size.height)))
        leftViewMode = .always
        leftView = viewLeftPadding
    }
    
    func addRightView(_ view: UIView) -> Void {
        rightViewMode = .always
        rightView = view
    }

}
