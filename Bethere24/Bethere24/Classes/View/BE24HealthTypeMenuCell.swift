//
//  BE24HealthTypeMenuCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/8/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24HealthTypeMenuCell: BE24TableViewCell {

    class func cellIdentifier() -> String {
        return "BE24HealthTypeMenuCell"
    }
    
    @IBOutlet weak var imgviewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var menuTitleAndIcon: [String: String]! {
        didSet {
            updateMenuItem()
        }
    }
    
    func updateMenuItem() -> Void {
        self.lblTitle.text = menuTitleAndIcon[kMenuTitleKeyName]
        self.lblTitle.textColor = UIColor(rgba: menuTitleAndIcon[kMenuColorKeyName]!)
        
        self.imgviewIcon.image = UIImage(named: menuTitleAndIcon[kMenuIconKeyName]!)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
