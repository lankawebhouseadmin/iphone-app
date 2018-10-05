//
//  BE24MenuVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

class BE24MenuVC: BE24TableViewController {

    fileprivate var menuItems: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = appManager().menuItems
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BE24MenuCell.cellIdentifer()) as! BE24MenuCell
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        appManager().selectedHealthType = nil
        appManager().selectedDayIndex   = nil
        let item = menuItems[indexPath.row]
        let segue = item["segue"]
        
        if segue == "LoginVC" {
            //
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "username")
            prefs.removeObject(forKey: "password")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! BE24LoginVC
            self.present(nextViewController, animated:true, completion:nil)
            
        }else{
            self.sideMenuController?.performSegue(withIdentifier: menuItems[indexPath.row][kMenuSegueKeyName]!, sender: self)
        }
        

    }
    
}
