//
//  BE24HealthTypeMenuVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/8/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class BE24HealthTypeMenuVC: BE24TableViewController {

    private var categories: [[String: String]]!
    var delegate: BE24HealthTypeMenuVCDelegate?
    
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24HealthTypeMenuCell.cellIdentifier()) as! BE24HealthTypeMenuCell
        cell.menuTitleAndIcon = categories[indexPath.row]
        return cell
    }
    
    //MARK: delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.healthTypeSelected(indexPath.row)
        self.dismissViewControllerAnimated(true) { 
            
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
    func healthTypeSelected(index: Int) -> Void
}