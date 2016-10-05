//
//  BE24HealthBaseVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/29/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24HealthBaseVC: BE24MainBaseVC {

    @IBOutlet weak var btnLeftDate: UIButton!
    @IBOutlet weak var btnRightDate: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewDetailBox: UIView!
    @IBOutlet weak var imgHealthIcon: UIImageView!
    @IBOutlet weak var lblHealthTitle: UILabel!
    @IBOutlet weak var lblTimes: UILabel!
    @IBOutlet weak var btnLeftHealthCategory: UIButton!
    @IBOutlet weak var btnRightHealthCategory: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupLayout() {
        super.setupLayout()
        
        self.viewDetailBox.makeRoundView(radius: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == graphCellIndex() {
            return UIScreen.mainScreen().bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    internal func graphCellIndex() -> Int {
        return 100
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
