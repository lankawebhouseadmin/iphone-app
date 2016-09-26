//
//  BE24MenuVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24MenuVC: BE24TableViewController {

    lazy var menuItems: [[String: String]] = {
        var _menuItems = [
            [
                kMenuIconKeyName : "iconMenuHeart",
                kMenuTitleKeyName : "Health Summary"
            ],
            [
                kMenuIconKeyName : "iconMenuHealth",
                kMenuTitleKeyName : "Health Score Details"
            ],
            [
                kMenuIconKeyName : "iconMenuAlert",
                kMenuTitleKeyName : "Alert Summary"
            ],
            [
                kMenuIconKeyName : "iconMenuGraph",
                kMenuTitleKeyName : "Historical Graphs"
            ],
            [
                kMenuIconKeyName : "iconMenuContact",
                kMenuTitleKeyName : "Contact Information"
            ],

        ]
        return _menuItems
    }()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24MenuCell.cellIdentifer()) as! BE24MenuCell
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    
}
