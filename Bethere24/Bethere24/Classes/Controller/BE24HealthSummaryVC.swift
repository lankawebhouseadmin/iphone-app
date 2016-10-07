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
    
    private var healthTypeForIndex: [HealthType] = [
        .InBathroom,
        .WithVisitors,
        .InDining,
        .InMotion,
        .InBedroom,
        .AwayFromHome,
        .InRecliner,
        .TakingMedication,
    ]
    private var currentStateData: [BE24StateModel]?
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthSummary
        self.viewMainPieCircle.delegate = self
    }
    
    override func graphCellIndex() -> Int {
        return 1
    }

    override func selectDateIndex(index: Int) {
        super.selectDateIndex(index)
        if statesData != nil {
            
            if statesData!.state.days.count > 0 {
                let dateString = statesData!.state.days[index]
                currentStateData = statesData!.state.statesByDay[dateString]
                viewMainPieCircle.reloadData()
            }
        }
    }
    
    private func showStateInfo(states: [BE24StateModel]) {
        
        if states.count > 0 {
            
            self.btnHealthScoreDetail.hidden = false
            self.btnHistoricalGraphs.hidden  = false
            self.btnAlert.hidden             = true
            
            self.lblTimes.hidden = false
            var timesString: String = "1 time"
            if states.count > 1 {
                timesString = String(states.count) + " times"
            }
            self.lblTimes.text = timesString
            
            var totalTimes = 0
            states.forEach({ (state: BE24StateModel) in
                totalTimes += state.actualTime
            })
            let state = states.first!
            let isMedication = state.type() == HealthType.TakingMedication
            let normalTitle = "Normal: "
            let totalTitle  = "Total: "
            let detailString = normalTitle + timeString(state.normalTime, isMedication: isMedication) + ",  " +
                               totalTitle  + timeString(totalTimes, isMedication: isMedication) + "\n\n" +
                               healthDetailReportString(state.type(), score: state.score)
            let attrDetailString = NSMutableAttributedString(string: detailString, attributes: nil)
            
            let boldFont = UIFont.boldSystemFontOfSize(12)
            let firstRange = NSMakeRange(0, normalTitle.characters.count)
            let secondRange = NSMakeRange(detailString.startIndex.distanceTo(detailString.rangeOfString(totalTitle)!.startIndex), totalTitle.characters.count)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: firstRange)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: secondRange)
            
//            self.lblHealthDetail.text = detailString
            self.lblHealthDetail.attributedText = attrDetailString
            
        } else {
            
            self.btnHealthScoreDetail.hidden = true
            self.btnHistoricalGraphs.hidden  = true
            self.btnAlert.hidden             = true
            self.lblTimes.hidden = true
            
            self.lblHealthDetail.text = "No data available"
        }
    }
    
    @IBAction func onPressLeftHealthType(sender: AnyObject) {
        viewMainPieCircle.prevSelect()
    }
    
    @IBAction func onPressRightHealthType(sender: AnyObject) {
        viewMainPieCircle.nextSelect()
    }
    
    
    // MARK: - BE24PieCirlceView delegate
    func pieCircleView(view: BE24PieCircleView, selectedIndex: Int) {
//        print (selectedIndex)
        let healthType = healthTypeForIndex[selectedIndex]
        
        var selectedStates: [BE24StateModel] = []
        if currentStateData != nil {
            currentStateData!.forEach({ (state: BE24StateModel) in
                if state.type() == healthType {
                    selectedStates.append(state)
                }
            })
        }
        
        let healthTypeData = appManager().categories[selectedIndex]
        self.lblHealthTitle.text = healthTypeData[kMenuTitleKeyName]
        self.lblHealthTitle.textColor = UIColor(rgba: healthTypeData[kMenuColorKeyName]!)
        self.imgHealthIcon.image = UIImage(named: healthTypeData[kMenuIconKeyName]!)

        showStateInfo(selectedStates)
        
    }
    
    func pieCircleView(view: BE24PieCircleView, categoryScoreForIndex: Int) -> Int {
        let healthType = healthTypeForIndex[categoryScoreForIndex]
        var score: Int = 0
        if currentStateData != nil {
            currentStateData!.forEach({ (state: BE24StateModel) in
                if state.type() == healthType {
                    score = state.score
                }
            })
        }
        return score
    }
    
}
