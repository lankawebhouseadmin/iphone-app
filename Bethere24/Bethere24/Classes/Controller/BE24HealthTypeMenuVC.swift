//
//  BE24HealthTypeMenuVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/8/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class BE24HealthTypeMenuVC: BE24TableViewController {

    fileprivate var categories: [[String: String]]!
    var delegate: BE24HealthTypeMenuVCDelegate?
    var showAllButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = appManager().categories
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAllButton {
            return categories.count + 1
        } else {
            return categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BE24HealthTypeMenuCell.cellIdentifier()) as! BE24HealthTypeMenuCell
        if showAllButton {
            if indexPath.row == 0 {
                cell.imgviewIcon.image = nil
                cell.lblTitle.text = "All"
                cell.lblTitle.textColor = UIColor.black
            } else {
                cell.menuTitleAndIcon = categories[indexPath.row - 1]
            }
        } else {
            cell.menuTitleAndIcon = categories[indexPath.row]
        }
        return cell
    }
    
    //MARK: delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.healthTypeSelected(indexPath.row)
        self.dismiss(animated: true) { 
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol BE24HealthTypeMenuVCDelegate {
    func healthTypeSelected(_ index: Int) -> Void
}
