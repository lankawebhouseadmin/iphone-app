//
//  BE24AlertContentCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24AlertContentCell: BE24TableViewCell {

    class func cellIdentifier() -> String {
        return "BE24AlertContentCell"
    }

    @IBOutlet weak var imgviewHealthCategory: UIImageView!
    @IBOutlet weak var lblCategoryType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNormalTimes: UILabel!
    @IBOutlet weak var lblActualTimes: UILabel!
    @IBOutlet weak var lblAlertContent: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
