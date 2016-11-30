//
//  BE24AlertFooterCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/14/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

class BE24AlertFooterCell: BE24TableViewCell {

    class func cellIdentifier() -> String {
        return "BE24AlertFooterCell"
    }
    
    var delegate: BE24AlertFooterCellDelegate?
    
    @IBOutlet weak var btnBack: UIButton!

    @IBAction func onPressBack(sender: AnyObject) {
        delegate?.alertFooterCellPressBack(sender)
    }
    
}

@objc
protocol BE24AlertFooterCellDelegate {
    func alertFooterCellPressBack(sender: AnyObject) -> Void
}