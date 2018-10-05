//
//  BE24HealthScoreVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class BE24HealthScoreVC: BE24HealthBaseVC, BE24HealthTypeMenuVCDelegate, BE24PieClockViewDelegate {

    @IBOutlet weak var btnSelectHealthType: UIButton!
    @IBOutlet weak var viewMainPieClockView: BE24PieClockView!
    
    @IBOutlet weak var btnHealthSummary: UIButton!
    @IBOutlet weak var btnHistoricalGraphs: UIButton!
    
    fileprivate var categories: [[String: String]]!
    
//    private var currentDateIndex: Int = 0
//    private var selectedHealthType: HealthType = .InBathroom

    fileprivate var currentStatesForHealtyType: [BE24StateModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = appManager().categories
        
        if appManager().selectedDayIndex != nil && appManager().selectedHealthType != nil {
            selectedHealthType = appManager().selectedHealthType!
            currentDateIndex = appManager().selectedDayIndex!
            self.selectDateIndex(currentDateIndex)
//            selectHealthType(appManager().selectedHealthType!, dateIndex: appManager().selectedDayIndex!)
        } else {
            selectHealthType(.InBathroom, dateIndex: 0)
        }
//        showStateInfo(nil)
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .healthScoreDetails
        self.viewMainPieClockView.delegate = self
//        self.viewMainPieCircleView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func graphCellIndex() -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == graphCellIndex() {
            var height = UIScreen.main.bounds.size.height - 360
            if height > UIScreen.main.bounds.width {
                height = UIScreen.main.bounds.width
            }
//            let rowAspectRatio: CGFloat = 1/1
            
            return height
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == graphCellIndex() {
            viewMainPieClockView.arrangeSublayout()
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func refreshData() {
        super.refreshData()
        selectDateIndex(currentDateIndex)
    }
    
    // MARK: - HealthType selecting
    @IBAction func onPressSelectHealthType(_ sender: AnyObject) -> Void {
//        print("select Health type")
        
        let healthTypeMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = 170
        var dialogSize = CGSize(width: 220, height: 360)
        if self.view.frame.height < dialogSize.height + 170 {
            dialogSize.height = self.view.frame.size.height - 190
        }
        formSheetController.presentationController?.contentViewSize = dialogSize  // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
//        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = .fade
        
        self.present(formSheetController, animated: true, completion: nil)

    }

    func healthTypeSelected(_ index: Int) {
        self.selectHealthType(healthTypeForIndex[index], dateIndex: currentDateIndex)
    }
    
    @IBAction func onPressLeftState(_ sender: AnyObject) {
        self.viewMainPieClockView.nextSelect()
    }
    
    @IBAction func onPressRightState(_ sender: AnyObject) {
        self.viewMainPieClockView.prevSelect()
    }
    
    @IBAction func onPressHealthSummaryButton(_ sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex   = currentDateIndex
        var segueName: String!
        if sender as? UIButton == self.btnHealthSummary {
            segueName = APPSEGUE_gotoHealthSummaryVC
        } else {
            segueName = APPSEGUE_gotoHistoricalGraphsVC
        }
        sideMenuController?.performSegue(withIdentifier: segueName, sender: self)

//        sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthSummaryVC, sender: self)
    }
    
    // MARK: - Select Date and health type
    override func selectDateIndex(_ index: Int) {
        super.selectDateIndex(index)
        if statesData != nil {
            
            stateDataOfCurrentDay = nil
            if statesData!.state.days.count > 0 {
                let dateString = statesData!.state.days[index]
                stateDataOfCurrentDay = statesData!.state.statesByDay[dateString]
                
                
//                viewMainPieCircleView.reloadData()
            }
            self.selectHealthType(selectedHealthType, dateIndex: index)

        }

    }
    
    override func dateString(_ dateString: String) -> String {

        if let date = DATE_FORMATTER.Default.date(from: dateString) {
            let calendar = Calendar.current
            if let aDaysNextday = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: date, options: []) {
                
                let nextDayString = DATE_FORMATTER.MonthDay.string(from: aDaysNextday)
                let selectedDayString = DATE_FORMATTER.MonthDay.string(from: date)
                let currentTimeString = statesData!.clientInfo.currentTimeDayString() //  BE24AppManager.defaultDayString(appManager().currentUser!.loginTime!)
                
                var resultString: String!
                if dateString == currentTimeString {
                    
                    let virtualDayStartTime = statesData!.clientInfo.getFormattedVirtualDayStartTime()
                    let currentTimeString = DATE_FORMATTER.TimeA.string(from: statesData!.clientInfo.currentTime)
                    let currentDayString  = DATE_FORMATTER.MonthDay.string(from: statesData!.clientInfo.currentTime)
                    resultString = "\(selectedDayString) \(virtualDayStartTime) to \(currentDayString) \(currentTimeString)"
                    /*
                    let currentTimeString = statesData!.clientInfo.currentTimeString // DATE_FORMATTER.StandardISO.stringFromDate(NSDate())
                    let stringVirtualToday: String = currentTimeString.substringToIndex(currentTimeString.startIndex.advancedBy(11)) + statesData!.clientInfo.virtualDayStartOriginal
                    let dateVirtualToday: NSDate = DATE_FORMATTER.StandardISO.dateFromString(stringVirtualToday)!
                    let loginTimeString = DATE_FORMATTER.TimeA.stringFromDate(appManager().currentUser!.loginTime!)
                    
                    if appManager().currentUser!.loginTime!.compare(dateVirtualToday) == .OrderedAscending {
                        let aDaysYesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: date, options: [])
                        let yesterDayString = DATE_FORMATTER.MonthDay.stringFromDate(aDaysYesterday!)
                        resultString = "\(yesterDayString) \(statesData!.clientInfo.virtualDayStartOriginal) - \(selectedDayString) \(loginTimeString)"
                    } else {
                        resultString = "\(selectedDayString) \(statesData!.clientInfo.virtualDayStartOriginal) - \(selectedDayString) \(loginTimeString)"
                    } */
                    
                } else {
                    let virtualDayStartTime = statesData!.clientInfo.getFormattedVirtualDayStartTime()
                    resultString = "\(selectedDayString) \(virtualDayStartTime) to \(nextDayString) \(virtualDayStartTime)"
                }
                return resultString
            }
        }
        return dateString
    }
    
    func selectHealthType(_ type: HealthType, dateIndex: Int) -> Void {
        
        selectedHealthType  = type
        currentDateIndex    = dateIndex
        
        let healthTypeData = appManager().categories[healthTypeForIndex.index(of: type)!]
        self.lblHealthTitle.text = healthTypeData[kMenuTitleKeyName]
//        self.lblHealthTitle.textColor = UIColor(rgba: healthTypeData[kMenuColorKeyName]!)
        do {
            self.lblHealthTitle.textColor = try UIColor(rgba_throws: healthTypeData[kMenuColorKeyName]!)
        }
        catch {
            print("error thrown")
        }
        
        self.imgHealthIcon.image = UIImage(named: healthTypeData[kMenuIconKeyName]!)
        
        self.btnSelectHealthType.setImage(self.imgHealthIcon.image, for: UIControlState())
        self.btnSelectHealthType.setTitle(self.lblHealthTitle.text, for: UIControlState())
        self.btnSelectHealthType.setTitleColor(self.lblHealthTitle.textColor, for: UIControlState())
        
        
        currentStatesForHealtyType.removeAll()
        
        if stateDataOfCurrentDay != nil {
            let dateString = statesData!.state.days[currentDateIndex]
//            let virtualDayStartTimeString = String(format: "2017/%@ %@", dateString, statesData!.virtualDayStartOrigin!)
//            if let virtualDayStartTime = DATE_FORMATTER.FullDate.dateFromString(virtualDayStartTimeString) {
//                let virtualDayEndTime = virtualDayStartTime.timeIntervalSince1970 + 3600 * 24
//                for state in stateDataOfCurrentDay! {
//                    let timeInterval = state.startTime.timeIntervalSince1970
//                    if (state.type() == type) && (virtualDayStartTime.timeIntervalSince1970 < timeInterval && timeInterval < virtualDayEndTime) {
//                        currentStatesForHealtyType.append(state)
//                    }
//
//                }
//            }
            for state in stateDataOfCurrentDay! {
                let stateDateString = state.dateString(statesData!.clientInfo.virtualDayStartOriginal) // DATE_FORMATTER.Default.stringFromDate(state.startTime)
                
                if (state.type() == type) && (stateDateString == dateString) {
                    currentStatesForHealtyType.append(state)
                }
            }
        }
        showAlertCount()

        self.viewMainPieClockView.reloadData()
        
    }
    
    // MARK: - BE24PieClockView delegate
    func statesForPieCount(_ view: BE24PieClockView) -> [BE24StateModel]? {
        if currentStatesForHealtyType.count == 0 {
            showStateInfo(nil)
        }
        return currentStatesForHealtyType
    }
    
    /*
    func numberOfPieCount(view: BE24PieClockView) -> Int {
        let count = currentStatesForHealtyType.count
        if count == 0 {
            showStateInfo(nil)
        }
        return count
    } */

    func pieClockView(_ view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel {
        let state = currentStatesForHealtyType[stateForIndex]
//        showStateInfo(state)
        return state
    }
    
    func pieClockView(_ view: BE24PieClockView, selectedStateIndex: Int) {
        showStateInfo(currentStatesForHealtyType[selectedStateIndex])
    }
    
    func shouldShowLoginTimeClockView(_ view: BE24PieClockView) -> Bool {
        let dateString = statesData!.state.days[currentDateIndex]
//        let loginTimeString = BE24AppManager.defaultDayString(appManager().currentUser!.loginTime!) // DATE_FORMATTER.Default.stringFromDate(appManager().currentUser!.loginTime!)
        let currentTimeString = statesData!.clientInfo.currentTimeDayString()
        
        return dateString == currentTimeString
    }
    
    // MARK: - Show Health infomation
    fileprivate func showStateInfo(_ state: BE24StateModel?) {
        
        if state != nil {
            
//            self.btnHealthSummary.hidden = false
            self.btnHistoricalGraphs.isHidden  = false
//            self.btnAlert.hidden             = true
            
            self.lblTimes.isHidden = false
            var timesString: String = "1 time"
            if currentStatesForHealtyType.count > 1 {
                timesString = String(currentStatesForHealtyType.count) + " times"
            }
            self.lblTimes.text = timesString
            
            var totalTimes = 0
            
            
            
            
            if(state!.type() == HealthType.TakingMedication)
            {
                totalTimes  = state!.actualTime
            }
            else
            {
                currentStatesForHealtyType.forEach({ (state: BE24StateModel) in
                    totalTimes += state.actualTime
                })
            }
            

            
//            currentStatesForHealtyType.forEach({ (state: BE24StateModel) in
//                totalTimes += state.actualTime
//            })

            let isMedication = (state!.type() == HealthType.TakingMedication)
            let normalTitle = "Normal: "
            let totalTitle  = "Total: "
            let fromTitle   = "From: "
            let toTitle     = "To: "
            let actualTitle = "Actual: "
            let detailString = normalTitle + timeString(state!.normalTime, isMedication: isMedication) + ",  " +
                totalTitle  + timeString(totalTimes, isMedication: isMedication) + "\n" +
                fromTitle   + timeString(state!.startTime) + ", " + toTitle + timeString(state!.endTime) + ", " + actualTitle + timeString(state!.actualTime, isMedication: isMedication) + "\n" +
                healthDetailReportString(state!.type(), score: state!.score)
            let actualString = detailString.replacingOccurrences(of: ",,", with: ",")
            let attrDetailString = NSMutableAttributedString(string: actualString, attributes: nil)
            
            let boldFont = UIFont.boldSystemFont(ofSize: 12)
            let firstRange = NSMakeRange(0, normalTitle.characters.count)
            
            let secondRange = NSMakeRange(actualString.characters.distance(from: actualString.startIndex, to: actualString.range(of: totalTitle)!.lowerBound), totalTitle.characters.count)
            let thirdRange  = NSMakeRange(actualString.characters.distance(from: actualString.startIndex, to: actualString.range(of: fromTitle)!.lowerBound), fromTitle.characters.count)
            let fourthRange = NSMakeRange(actualString.characters.distance(from: actualString.startIndex, to: actualString.range(of: toTitle)!.lowerBound), toTitle.characters.count)
            let fivethRange = NSMakeRange(actualString.characters.distance(from: actualString.startIndex, to: actualString.range(of: actualTitle)!.lowerBound), actualTitle.characters.count)
            
            attrDetailString.addAttributes([kCTFontAttributeName as NSAttributedStringKey : boldFont], range: firstRange)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: secondRange)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: thirdRange)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: fourthRange)
            attrDetailString.addAttributes([NSAttributedStringKey.font : boldFont], range: fivethRange)
            
            //            self.lblHealthDetail.text = detailString
            self.lblHealthDetail.attributedText = attrDetailString
            
        } else {
            
//            self.btnHealthSummary.hidden     = true
            self.btnHistoricalGraphs.isHidden  = true
//            self.btnAlert.hidden             = true
            self.lblTimes.isHidden             = true
            self.constraintLeftOfFirstButton.constant = 0
            
            self.lblHealthDetail.text = "No data available"
        }
    }
    
    fileprivate func timeString(_ time: Date, formatString: String = "h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: time)
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
