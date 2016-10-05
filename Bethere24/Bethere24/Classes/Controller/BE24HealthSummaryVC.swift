//
//  BE24HealthSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24HealthSummaryVC: BE24HealthBaseVC, BE24PieCircleViewDelegate {

    @IBOutlet weak var viewMainPieCircle: BE24PieCircleView!
    @IBOutlet weak var btnHealthScoreDetail: UIButton!
    @IBOutlet weak var btnHistoricalGraphs: UIButton!
    @IBOutlet weak var btnAlert: UIButton!
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthSummary
        self.viewMainPieCircle.delegate = self
    }
    
    // MARK: - BE24PieCirlceView delegate
    func pieCircleView(view: BE24PieCircleView, selectedIndex: Int) {
        print (selectedIndex)
    }
    
    func pieCircleView(view: BE24PieCircleView, categoryScoreForIndex: Int) -> Int {
        return random() % 11
    }
    
    override func graphCellIndex() -> Int {
        return 1
    }
}
