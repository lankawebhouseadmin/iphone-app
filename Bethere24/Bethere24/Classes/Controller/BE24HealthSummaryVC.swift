//
//  BE24HealthSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
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
        self.pageType = .healthSummary
        self.viewMainPieCircle.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func graphCellIndex() -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == graphCellIndex() {
            var height = UIScreen.main.bounds.size.height - 320
            if height > UIScreen.main.bounds.width {
                height = UIScreen.main.bounds.width
            }
            return height
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func refreshData() {
        super.refreshData()
        selectDateIndex(currentDateIndex)
    }

    override func selectDateIndex(_ index: Int) {
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
    
    fileprivate func showStateInfo(_ states: [BE24StateModel]) {
        
        if states.count > 0 {
            
            self.btnHealthScoreDetail.isHidden = false
            self.btnHistoricalGraphs.isHidden  = false
//            self.btnAlert.hidden             = true
            
            self.lblTimes.isHidden = false
            var timesString: String = "1 time"
            if states.count > 1 {
                timesString = String(states.count) + " times"
            }
            self.lblTimes.text = timesString
            
            
            var totalTimes = 0
            
            
            let state1 = states.first!
            if(state1.type() == HealthType.TakingMedication)
            {
//                totalTimes  = states[0].actualTime
                states.forEach({ (state: BE24StateModel) in
                    totalTimes += state.actualTime
                })
            }
            else
            {
                states.forEach({ (state: BE24StateModel) in
                    totalTimes += state.actualTime
                })
            }

            
            let state = states.first!
            let isMedication = (state.type() == HealthType.TakingMedication)
            let normalTitle = "Normal: "
            let totalTitle  = "Total: "
            let detailString = normalTitle + timeString(state.normalTime, isMedication: isMedication) + "  " +
                               totalTitle  + timeString(totalTimes, isMedication: isMedication) + "\n\n" +
                               healthDetailReportString(state.type(), score: state.score)
            let attrDetailString = NSMutableAttributedString(string: detailString, attributes: nil)
            
            let boldFont = UIFont.boldSystemFont(ofSize: 12)
            let firstRange = NSMakeRange(0, normalTitle.characters.count)
            let secondRange = NSMakeRange(detailString.characters.distance(from: detailString.startIndex, to: detailString.range(of: totalTitle)!.lowerBound), totalTitle.characters.count)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: firstRange)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: secondRange)
            
//            self.lblHealthDetail.text = detailString
            self.lblHealthDetail.attributedText = attrDetailString
            
        } else {
            
            self.btnHealthScoreDetail.isHidden = false //true
            self.btnHistoricalGraphs.isHidden  = true
//            self.btnAlert.hidden             = true
            self.lblTimes.isHidden = true
            
            self.lblHealthDetail.text = "No data available"
        }
        
        showAlertCount()
    }
    
    @IBAction func onPressLeftHealthType(_ sender: AnyObject) {
        viewMainPieCircle.prevSelect()
    }
    
    @IBAction func onPressRightHealthType(_ sender: AnyObject) {
        viewMainPieCircle.nextSelect()
    }
    
    @IBAction func onPressHealthScoreButton(_ sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex   = currentDateIndex
        var segueName: String!
        if sender as? UIButton == self.btnHealthScoreDetail {
            segueName = APPSEGUE_gotoHealthScoreVC
        } else {
            segueName = APPSEGUE_gotoHistoricalGraphsVC
        }
        sideMenuController?.performSegue(withIdentifier: segueName, sender: self)

//        sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthScoreVC, sender: self)
    }
    
    // MARK: - BE24PieCirlceView delegate
    func pieCircleView(_ view: BE24PieCircleView, selectedIndex: Int) {
//        print (selectedIndex)
        selectedHealthType = healthTypeForIndex[selectedIndex]
        
        var selectedStates: [BE24StateModel] = []
        
        if stateDataOfCurrentDay != nil {
            for state in stateDataOfCurrentDay! {
                if state.type() == selectedHealthType {
                    selectedStates.append(state)
                }
            }
        }
        
        let healthTypeData = appManager().categories[selectedIndex]
        self.lblHealthTitle.text = healthTypeData[kMenuTitleKeyName]
        do {
            self.lblHealthTitle.textColor = try UIColor(rgba_throws: healthTypeData[kMenuColorKeyName]!)
        }
        catch {
            print("throws error")
        }
        self.imgHealthIcon.image = UIImage(named: healthTypeData[kMenuIconKeyName]!)

        showStateInfo(selectedStates)
        
    }
    
    func pieCircleView(_ view: BE24PieCircleView, categoryScoreForIndex: Int) -> Int {
        let healthType = healthTypeForIndex[categoryScoreForIndex]
        var score: Int = 0
        if stateDataOfCurrentDay != nil {
            for state in stateDataOfCurrentDay! {
                if state.type() == healthType {
                    if score == 0 {
                        score = state.score
                    } else if score > state.score {
                        score = state.score
                    }
                }
            }
        }
        return score
    }
    
}
