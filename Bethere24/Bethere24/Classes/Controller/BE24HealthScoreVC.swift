//
//  BE24HealthScoreVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24HealthScoreVC: BE24HealthBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthScoreDetails
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func graphCellIndex() -> Int {
        return 2
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
