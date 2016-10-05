
//
//  BE24AlertSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24AlertSummaryVC: BE24MainBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .AlertSummary
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertHeaderCell.cellIdentifier()) as! BE24AlertHeaderCell
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertContentCell.cellIdentifier()) as! BE24AlertContentCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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

extension BE24AlertSummaryVC: BE24AlertHeaderCellDelegate {
    func alertSelectedLeftDate() -> String {
        return "10/3 - Wed."
    }
    
    func alertSelectedRightDate() -> String {
        return "10/5 - Fri."
    }
    
    func alertSelectedHealthTypeIndex(index: Int) {
        
    }
    
    func alertSelectedWeekDayType(type: AlertType) {
        
    }
}