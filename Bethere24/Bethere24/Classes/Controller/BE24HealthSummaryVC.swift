//
//  BE24HealthSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24HealthSummaryVC: BE24HealthBaseVC {

    @IBOutlet weak var viewMainPieCircle: BE24PieCircleView!
    @IBOutlet weak var btnHealthScoreDetail: UIButton!
    @IBOutlet weak var btnHistoricalGraphs: UIButton!
    @IBOutlet weak var btnAlert: UIButton!
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthSummary
        
    }
    
}
