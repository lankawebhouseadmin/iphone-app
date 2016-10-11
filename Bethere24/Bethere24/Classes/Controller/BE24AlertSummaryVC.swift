
//
//  BE24AlertSummaryVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24AlertSummaryVC: BE24StateBaseVC {
    
    var alertModels: [BE24AlertModel] = []
    var currentSelectedDateIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if statesData!.alert != nil {
            alertModels = statesData!.alert!
        }
    }

    override func setupLayout() {
        super.setupLayout()
        self.pageType = .AlertSummary
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(BE24AlertHeaderCell.cellIdentifier()) as! BE24AlertHeaderCell
        if currentSelectedDateIndex == nil {
            cell.segmentType.selectedSegmentIndex = 1
            cell.btnRightDate.hidden = true
            cell.btnLeftDate.hidden  = true
            cell.lblTitle.text = "All"
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
                    cell.lblTitle.text = self.dateString(dayString)
                }
            }
        }
        cell.delegate = self
        return cell
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

extension BE24AlertSummaryVC: BE24AlertHeaderCellDelegate {
    func alertSelectedLeftDate() -> String {
        return "10/3 - Wed."
    }
    
    func alertSelectedRightDate() -> String {
        return "10/5 - Fri."
    }
    
    func alertSelectedHealthTypeIndex(index: Int) {
        
    }
    
    func alertSelectedDayIndex(index: Int?) {
        if statesData!.alert != nil {
            if index == nil {
                
                alertModels = statesData!.alert!
                
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
}