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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appManager().selectedDayIndex != nil && appManager().selectedHealthType != nil {
            selectDateIndex(appManager().selectedDayIndex!)
//            currentDateIndex = appManager().selectedDayIndex!
            viewMainPieCircle.selectCategoryType(appManager().selectedHealthType!)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.pageType = .HealthSummary
        self.viewMainPieCircle.delegate = self
    }
    
    override func graphCellIndex() -> Int {
        return 1
    }
    
    override func refreshData() {
        super.refreshData()
        selectDateIndex(currentDateIndex)
    }

    override func selectDateIndex(index: Int) {
        super.selectDateIndex(index)
        if statesData != nil {
            
            stateDataOfCurrentDay = nil
            if statesData!.state.days.count > 0 {
                let dateString = statesData!.state.days[index]
                stateDataOfCurrentDay = statesData!.state.statesByDay[dateString]
            }
            viewMainPieCircle.reloadData()
        }
    }
    
    private func showStateInfo(states: [BE24StateModel]) {
        
        if states.count > 0 {
            
            self.btnHealthScoreDetail.hidden = false
            self.btnHistoricalGraphs.hidden  = false
//            self.btnAlert.hidden             = true
            
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
            let isMedication = (state.type() == HealthType.TakingMedication)
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
//            self.btnAlert.hidden             = true
            self.lblTimes.hidden = true
            
            self.lblHealthDetail.text = "No data available"
        }
        
        showAlertCount()
    }
    
    @IBAction func onPressLeftHealthType(sender: AnyObject) {
        viewMainPieCircle.prevSelect()
    }
    
    @IBAction func onPressRightHealthType(sender: AnyObject) {
        viewMainPieCircle.nextSelect()
    }
    
    @IBAction func onPressHealthScoreButton(sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex   = currentDateIndex
        var segueName: String!
        if sender as? UIButton == self.btnHealthScoreDetail {
            segueName = APPSEGUE_gotoHealthScoreVC
        } else {
            segueName = APPSEGUE_gotoHistoricalGraphsVC
        }
        sideMenuController?.performSegueWithIdentifier(segueName, sender: self)

//        sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthScoreVC, sender: self)
    }
    
    // MARK: - BE24PieCirlceView delegate
    func pieCircleView(view: BE24PieCircleView, selectedIndex: Int) {
//        print (selectedIndex)
        selectedHealthType = healthTypeForIndex[selectedIndex]
        
        var selectedStates: [BE24StateModel] = []
        if stateDataOfCurrentDay != nil {
            stateDataOfCurrentDay!.forEach({ (state: BE24StateModel) in
                if state.type() == selectedHealthType {
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
        if stateDataOfCurrentDay != nil {
            stateDataOfCurrentDay!.forEach({ (state: BE24StateModel) in
                if state.type() == healthType {
                    if score == 0 {
                        score = state.score
                    } else if score > state.score {
                        score = state.score
                    }
                }
            })
        }
        return score
    }
    
}
