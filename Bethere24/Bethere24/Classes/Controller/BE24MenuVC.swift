//
//  BE24MenuVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24MenuVC: BE24TableViewController {

    private var menuItems: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = appManager().menuItems
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24MenuCell.cellIdentifer()) as! BE24MenuCell
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.sideMenuController?.performSegueWithIdentifier(menuItems[indexPath.row][kMenuSegueKeyName]!, sender: self)
    }
    
}
