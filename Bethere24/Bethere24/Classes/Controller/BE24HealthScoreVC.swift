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
    
    private var categories: [[String: String]]!
    
//    private var currentDateIndex: Int = 0
//    private var selectedHealthType: HealthType = .InBathroom

    private var currentStatesForHealtyType: [BE24StateModel] = []
    
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
        self.pageType = .HealthScoreDetails
        self.viewMainPieClockView.delegate = self
//        self.viewMainPieCircleView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func graphCellIndex() -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == graphCellIndex() {
            var height = UIScreen.mainScreen().bounds.size.height - 360
            if height > UIScreen.mainScreen().bounds.width {
                height = UIScreen.mainScreen().bounds.width
            }
            return height
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == graphCellIndex() {
            viewMainPieClockView.arrangeSublayout()
        }
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    override func refreshData() {
        super.refreshData()
        selectDateIndex(currentDateIndex)
    }
    
    // MARK: - HealthType selecting
    @IBAction func onPressSelectHealthType(sender: AnyObject) -> Void {
//        print("select Health type")
        
        let healthTypeMenuVC = self.storyboard!.instantiateViewControllerWithIdentifier("BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = 170
        var dialogSize = CGSizeMake(220, 360)
        if self.view.frame.height < dialogSize.height + 170 {
            dialogSize.height = self.view.frame.size.height - 190
        }
        formSheetController.presentationController?.contentViewSize = dialogSize  // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
//        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = .Fade
        
        self.presentViewController(formSheetController, animated: true, completion: nil)

    }

    func healthTypeSelected(index: Int) {
        self.selectHealthType(healthTypeForIndex[index], dateIndex: currentDateIndex)
    }
    
    @IBAction func onPressLeftState(sender: AnyObject) {
        self.viewMainPieClockView.nextSelect()
    }
    
    @IBAction func onPressRightState(sender: AnyObject) {
        self.viewMainPieClockView.prevSelect()
    }
    
    @IBAction func onPressHealthSummaryButton(sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex   = currentDateIndex
        var segueName: String!
        if sender as? UIButton == self.btnHealthSummary {
            segueName = APPSEGUE_gotoHealthSummaryVC
        } else {
            segueName = APPSEGUE_gotoHistoricalGraphsVC
        }
        sideMenuController?.performSegueWithIdentifier(segueName, sender: self)

//        sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthSummaryVC, sender: self)
    }
    
    // MARK: - Select Date and health type
    override func selectDateIndex(index: Int) {
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
    
    override func dateString(dateString: String) -> String {

        if let date = DATE_FORMATTER.Default.dateFromString(dateString) {
            let calendar = NSCalendar.currentCalendar()
            if let aDaysNextday = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: []) {
                let nextDayString = DATE_FORMATTER.MonthDay.stringFromDate(aDaysNextday)
                let selectedDayString = DATE_FORMATTER.MonthDay.stringFromDate(date)
                let todayString = DATE_FORMATTER.Default.stringFromDate(NSDate())
                var resultString: String!
                if dateString == todayString {
                    let stringToday = DATE_FORMATTER.StandardISO.stringFromDate(NSDate())
                    let stringVirtualToday: String = stringToday.substringToIndex(stringToday.startIndex.advancedBy(11)) + statesData!.virtualDayStartOrigin!
                    let dateVirtualToday: NSDate = DATE_FORMATTER.StandardISO.dateFromString(stringVirtualToday)!
                    let loginTimeString = DATE_FORMATTER.TimeA.stringFromDate(appManager().currentUser!.loginTime!)
                    if appManager().currentUser!.loginTime!.compare(dateVirtualToday) == .OrderedAscending {
                        let aDaysYesterday = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])
                        let yesterDayString = DATE_FORMATTER.MonthDay.stringFromDate(aDaysYesterday!)
                        resultString = "\(yesterDayString) \(statesData!.virtualDayStart!) - \(selectedDayString) \(loginTimeString)"
                    } else {
                        resultString = "\(selectedDayString) \(statesData!.virtualDayStart!) - \(selectedDayString) \(loginTimeString)"
                    }
                    
                } else {
                    resultString = "\(selectedDayString) \(statesData!.virtualDayStart!) - \(nextDayString) \(statesData!.virtualDayStart!)"
                }
                return resultString
            }
        }
        return dateString
    }
    
    func selectHealthType(type: HealthType, dateIndex: Int) -> Void {
        
        selectedHealthType  = type
        currentDateIndex    = dateIndex
        
        let healthTypeData = appManager().categories[healthTypeForIndex.indexOf(type)!]
        self.lblHealthTitle.text = healthTypeData[kMenuTitleKeyName]
        self.lblHealthTitle.textColor = UIColor(rgba: healthTypeData[kMenuColorKeyName]!)
        self.imgHealthIcon.image = UIImage(named: healthTypeData[kMenuIconKeyName]!)
        
        self.btnSelectHealthType.setImage(self.imgHealthIcon.image, forState: .Normal)
        self.btnSelectHealthType.setTitle(self.lblHealthTitle.text, forState: .Normal)
        self.btnSelectHealthType.setTitleColor(self.lblHealthTitle.textColor, forState: .Normal)
        
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
                let stateDateString = state.dateString(statesData!.virtualDayStartOrigin!) // DATE_FORMATTER.Default.stringFromDate(state.startTime)
                
                if (state.type() == type) && (stateDateString == dateString) {
                    currentStatesForHealtyType.append(state)
                }
            }
        }
        showAlertCount()

        self.viewMainPieClockView.reloadData()
        
    }
    
    // MARK: - BE24PieClockView delegate
    func statesForPieCount(view: BE24PieClockView) -> [BE24StateModel]? {
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

    func pieClockView(view: BE24PieClockView, stateForIndex: Int) -> BE24StateModel {
        let state = currentStatesForHealtyType[stateForIndex]
//        showStateInfo(state)
        return state
    }
    
    func pieClockView(view: BE24PieClockView, selectedStateIndex: Int) {
        showStateInfo(currentStatesForHealtyType[selectedStateIndex])
    }
    
    func shouldShowLoginTimeClockView(view: BE24PieClockView) -> Bool {
        let dateString = statesData!.state.days[currentDateIndex]
        let todayString = DATE_FORMATTER.Default.stringFromDate(NSDate())
        return dateString == todayString
    }
    
    // MARK: - Show Health infomation
    private func showStateInfo(state: BE24StateModel?) {
        
        if state != nil {
            
//            self.btnHealthSummary.hidden = false
            self.btnHistoricalGraphs.hidden  = false
//            self.btnAlert.hidden             = true
            
            self.lblTimes.hidden = false
            var timesString: String = "1 time"
            if currentStatesForHealtyType.count > 1 {
                timesString = String(currentStatesForHealtyType.count) + " times"
            }
            self.lblTimes.text = timesString
            
            var totalTimes = 0
            currentStatesForHealtyType.forEach({ (state: BE24StateModel) in
                totalTimes += state.actualTime
            })

            let isMedication = (state!.type() == HealthType.TakingMedication)
            let normalTitle = "Normal: "
            let totalTitle  = "Total: "
            let fromTitle   = "From: "
            let toTitle     = "To: "
            let actualTitle = "Actual: "
            let detailString = normalTitle + timeString(state!.normalTime, isMedication: isMedication) + ",  " +
                totalTitle  + timeString(totalTimes, isMedication: isMedication) + "\n" +
                fromTitle   + timeString(state!.startTime) + ", " + toTitle + timeString(state!.endTime) + ", " + actualTitle + timeString(state!.actualTime) + "\n" +
                healthDetailReportString(state!.type(), score: state!.score)
            let attrDetailString = NSMutableAttributedString(string: detailString, attributes: nil)
            
            let boldFont = UIFont.boldSystemFontOfSize(12)
            let firstRange = NSMakeRange(0, normalTitle.characters.count)
            let secondRange = NSMakeRange(detailString.startIndex.distanceTo(detailString.rangeOfString(totalTitle)!.startIndex), totalTitle.characters.count)
            let thirdRange  = NSMakeRange(detailString.startIndex.distanceTo(detailString.rangeOfString(fromTitle)!.startIndex), fromTitle.characters.count)
            let fourthRange = NSMakeRange(detailString.startIndex.distanceTo(detailString.rangeOfString(toTitle)!.startIndex), toTitle.characters.count)
            let fivethRange = NSMakeRange(detailString.startIndex.distanceTo(detailString.rangeOfString(actualTitle)!.startIndex), actualTitle.characters.count)
            
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: firstRange)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: secondRange)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: thirdRange)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: fourthRange)
            attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: fivethRange)
            
            //            self.lblHealthDetail.text = detailString
            self.lblHealthDetail.attributedText = attrDetailString
            
        } else {
            
//            self.btnHealthSummary.hidden     = true
            self.btnHistoricalGraphs.hidden  = true
//            self.btnAlert.hidden             = true
            self.lblTimes.hidden             = true
            self.constraintLeftOfFirstButton.constant = 0
            
            self.lblHealthDetail.text = "No data available"
        }
    }
    
    private func timeString(time: NSDate, formatString: String = "h:mm a") -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.stringFromDate(time)
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
