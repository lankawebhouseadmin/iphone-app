//
//  BE24MenuCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24MenuCell: UITableViewCell {
    
    class func cellIdentifer() -> String {
        return "BE24MenuCell"
    }
    
    @IBOutlet weak var imgMenuIcon: UIImageView!
    @IBOutlet weak var lblMenuTitle: UILabel!
    
    private var _menuItem: [String: String]!
    
    var menuItem: [String: String] {
        set {
            _menuItem = newValue
            self.imgMenuIcon.image = UIImage(named: newValue[kMenuIconKeyName]!)
            self.lblMenuTitle.text = newValue[kMenuTitleKeyName]
        }
        get {
            return _menuItem
        }
    }
    
}
