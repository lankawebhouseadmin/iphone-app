
//
//  BE24AlertSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class BE24AlertSummaryVC: BE24StateBaseVC, BE24HealthTypeMenuVCDelegate {
    
    var alertModels: [BE24AlertModel] = []
    var currentSelectedDateIndex: Int?
    var selectedHealthType: HealthType?
    var isBackable: Bool = false
    var prevVC: BE24HealthBaseVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if appManager().selectedHealthType != nil && appManager().prevVCForAlertVC != nil {
            isBackable = true
            prevVC = appManager().prevVCForAlertVC!
            healthTypeSelected(healthTypeForIndex.indexOf(appManager().selectedHealthType!)! + 1)
        } else {
            healthTypeSelected(0)
        }
        
        /*
        if statesData!.alert != nil {
            alertModels = statesData!.alert!
        } */
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .AlertSummary
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshData() {
        super.refreshData()
        currentSelectedDateIndex = nil
        alertSelectedDayIndex(nil)
        self.tableView.reloadData()
    }
    
    // MARK: - HealthType selecting
    private func onPressSelectHealthType() -> Void {
//        print("select Health type")
        
        let healthTypeMenuVC = self.storyboard!.instantiateViewControllerWithIdentifier("BE24HealthTypeMenuVC") as! BE24HealthTypeMenuVC
        healthTypeMenuVC.showAllButton = true
        healthTypeMenuVC.delegate = self
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: healthTypeMenuVC)
        formSheetController.presentationController?.portraitTopInset = 170
        var dialogSize = CGSizeMake(220, 400)
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
        if index == 0 {
            selectedHealthType = nil
        } else {
            selectedHealthType = healthTypeForIndex[index - 1]
        }
        
        if statesData!.alert != nil {
            if index == 0 {
                
                alertModels = statesData!.alert!
                
            } else {

                alertModels.removeAll()
                statesData!.alert!.forEach({ (alert: BE24AlertModel) in
                    if alert.type() == selectedHealthType {
                        alertModels.append(alert)
                    }
                })
            }
        }
        self.tableView.reloadData()
        
    }
    
    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isBackable {
            return 0
        } else {
            return 90
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isBackable {
            let screenSize = UIScreen.mainScreen().bounds.size
            var footerHeight = screenSize.height - 114 - CGFloat(80 * alertModels.count)
            if footerHeight < 50 {
                footerHeight = 50
            }
            return footerHeight
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isBackable {
            return nil
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertHeaderCell.cellIdentifier()) as! BE24AlertHeaderCell
            if currentSelectedDateIndex == nil {
                cell.segmentType.selectedSegmentIndex = 1
                cell.btnRightDate.hidden = true
                cell.btnLeftDate.hidden  = true
                if selectedHealthType == nil {
                    cell.btnHealthType.setTitle("All", forState: .Normal)
                    cell.btnHealthType.setImage(nil, forState: .Normal)
                } else {
                    
                    let healthTypeData = appManager().categories[healthTypeForIndex.indexOf(selectedHealthType!)!]
                    
                    cell.btnHealthType.setImage(UIImage(named: healthTypeData[kMenuIconKeyName]!), forState: .Normal)
                    cell.btnHealthType.setTitle(healthTypeData[kMenuTitleKeyName], forState: .Normal)
                    cell.btnHealthType.setTitleColor(UIColor(rgba: healthTypeData[kMenuColorKeyName]!), forState: .Normal)
                    
                }
                cell.btnHealthType.enabled = true
            } else {
                if statesData != nil {
                    cell.segmentType.selectedSegmentIndex = 0
                    cell.btnLeftDate.hidden = true
                    cell.btnRightDate.hidden = true
                    if currentSelectedDateIndex! > 0 {
                        cell.btnRightDate.hidden = false
                    }
                    if currentSelectedDateIndex < statesData!.state.days.count - 1 {
                        cell.btnLeftDate.hidden = false
                    }
                    if statesData!.state.days.count > currentSelectedDateIndex {
                        let dayString = statesData!.state.days[currentSelectedDateIndex!]

                        cell.btnHealthType.setTitle(self.dateString(dayString), forState: .Normal)
                        cell.btnHealthType.setImage(nil, forState: .Normal)

                    }
                }
                cell.btnHealthType.enabled = false
            }
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isBackable {
            let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertFooterCell.cellIdentifier()) as! BE24AlertFooterCell
            cell.delegate = self
            if prevVC! is BE24HealthSummaryVC {
                cell.btnBack.setImage(UIImage(named: "iconMenuHeart"), forState: .Normal)
            } else if prevVC! is BE24HealthScoreVC {
                cell.btnBack.setImage(UIImage(named: "iconMenuHealth"), forState: .Normal)
            } else if prevVC! is BE24HistoricalGraphsVC {
                cell.btnBack.setImage(UIImage(named: "iconMenuGraph"), forState: .Normal)
            } else {
                cell.btnBack.hidden = true
            }
            return cell
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertContentCell.cellIdentifier()) as! BE24AlertContentCell
        
        let alert = alertModels[indexPath.row]
        let categoryData: [String: String] = appManager().categories[healthTypeForIndex.indexOf(alert.type())!]
        let iconName = categoryData[kMenuIconKeyName]! + "White"
        let color = UIColor(rgba: categoryData[kMenuColorKeyName]!)
        let categoryTitle = categoryData[kMenuTitleKeyName]
        
        cell.imgviewHealthCategory.backgroundColor = color
        cell.imgviewHealthCategory.image = UIImage(named: iconName)
        cell.lblCategoryType.text = categoryTitle
        
        cell.lblTime.text = DATE_FORMATTER.ForAlert.stringFromDate(alert.alertTime)
        
        
        let isMedication = (alert.type() == HealthType.TakingMedication)
        let normalTitle = "Normal: "
        let actualTitle  = "Actual: "
        let detailString = normalTitle + timeString(alert.normalTime, isMedication: isMedication) + ",  " +
            actualTitle  + timeString(alert.actualTime, isMedication: isMedication) + "\n" +
            healthDetailReportString(alert.type(), score: alert.score)
        
        let boldFont = UIFont.boldSystemFontOfSize(12)
        let attrDetailString = NSMutableAttributedString(string: detailString, attributes: [NSFontAttributeName : boldFont])
        
        let actualStringStartIndex = detailString.startIndex.distanceTo(detailString.rangeOfString(actualTitle)!.startIndex)
        let actualStringEndIndex = detailString.startIndex.distanceTo(detailString.rangeOfString("\n")!.startIndex)
//        let firstRange = NSMakeRange(0, actualStringStartIndex - 1)
        let secondRange = NSMakeRange(actualStringStartIndex, actualStringEndIndex - actualStringStartIndex)
//        attrDetailString.addAttributes([NSFontAttributeName : boldFont], range: firstRange)
        let borderColor = BE24AppManager.colorForScore(alert.score)
        attrDetailString.addAttributes([NSForegroundColorAttributeName: borderColor], range: secondRange)
        
        //            self.lblHealthDetail.text = detailString
        cell.lblAlertContent.attributedText = attrDetailString

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertModels.count
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

extension BE24AlertSummaryVC: BE24AlertHeaderCellDelegate, BE24AlertFooterCellDelegate {
    
    func alertSelectedDayIndex(index: Int?) {
        if statesData!.alert != nil {
            if index == nil {
                if selectedHealthType == nil {
                alertModels = statesData!.alert!
                } else {
                    alertModels.removeAll()
                    statesData!.alert!.forEach({ (alert: BE24AlertModel) in
                        if alert.type() == selectedHealthType {
                            alertModels.append(alert)
                        }
                    })
                }
                
            } else {
                let dayString = statesData!.state.days[index!]
                alertModels.removeAll()
                statesData!.alert!.forEach({ (alert: BE24AlertModel) in
                    if dayString == alert.dateString() {
                        alertModels.append(alert)
                    }
                })
            }
            
        }
    }
    
    func alertSelectedWeekDayType(type: AlertType) {
        if type == .Day {
            currentSelectedDateIndex = 0
//            self.tableView.reloadData()
        } else {
            currentSelectedDateIndex = nil
//            self.tableView.reloadData()
        }
        alertSelectedDayIndex(currentSelectedDateIndex)
        self.tableView.reloadData()
    }
    
    func alertSelectedDayStep(step: Int) {
        if currentSelectedDateIndex != nil {
            currentSelectedDateIndex! -= step
            alertSelectedDayIndex(currentSelectedDateIndex)
            self.tableView.reloadData()
        }
    }
    
    func alertChooseHealthType() {
        onPressSelectHealthType()
    }
    
    func alertFooterCellPressBack(sender: AnyObject) {
        if prevVC! is BE24HealthSummaryVC {
            sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthSummaryVC, sender: self)
        } else if prevVC! is BE24HealthScoreVC {
            sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHealthScoreVC, sender: self)
        } else if prevVC! is BE24HistoricalGraphsVC {
            sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHistoricalGraphsVC, sender: self)
        }

    }
}