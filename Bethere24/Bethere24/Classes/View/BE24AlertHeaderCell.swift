//
//  BE24AlertHeaderCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

enum AlertType {
    case Week
    case Day
}

class BE24AlertHeaderCell: BE24TableViewCell {

    class func cellIdentifier() -> String {
        return "BE24AlertHeaderCell"
    }
    
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var btnLeftDate: UIButton!
    @IBOutlet weak var btnRightDate: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgviewHealthCategory: UIImageView!
    
    var alertType: AlertType = .Week
    
    private var _currentDateIndex: Int = 0
    var currentDateIndex: Int {
        set {
            _currentDateIndex = newValue
            
        }
        get {
           return _currentDateIndex
        }
    }
    
    var delegate: BE24AlertHeaderCellDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLeftDate.hidden = true
        self.btnRightDate.hidden = true
        self.lblTitle.text = "All"
    }
    
    @IBAction func onPressChangeWeekDayType(sender: AnyObject) {
        
        if self.segmentType.selectedSegmentIndex == 0 {
            self.delegate?.alertSelectedWeekDayType(.Day)
//            setAlertType(.Day)
            //            self.delegate?.alertSelectedWeekDayType(.Day)
        } else {
            self.delegate?.alertSelectedWeekDayType(.Week)
//            setAlertType(.Week)
            //            self.delegate?.alertSelectedWeekDayType(.Week)
        }
    }
    
    @IBAction func onPressLeftDate(sender: AnyObject) {
//        currentDateIndex += 1
//        selectDateIndex(currentDateIndex)
        self.delegate?.alertSelectedDayStep(-1)
    }
    
    @IBAction func onPressRightDate(sender: AnyObject) {
//        currentDateIndex -= 1
//        selectDateIndex(currentDateIndex)
        self.delegate?.alertSelectedDayStep(1)
    }
    

    private func setAlertType(type: AlertType) {
        alertType = type
        if alertType == .Week {
            self.btnLeftDate.hidden = true
            self.btnRightDate.hidden = true
            self.imgviewHealthCategory.image = nil
            self.lblTitle.text = "All"
            
//            self.delegate?.alertSelectedDayIndex(nil)
            
        } else {
            self.btnLeftDate.hidden = false
            self.btnRightDate.hidden = false
            self.imgviewHealthCategory.image = nil
//            self.lblTitle.text = "10/4 - Tue."
            
//            self.delegate?.alertSelectedDayIndex(currentDateIndex)
            
        }
    }
    
    internal func selectDateIndex(index: Int) {
        
        if let stateData = BE24AppManager.sharedManager.stateData {
            if stateData.count > 0 {
                
                let locationModelData = stateData.first!
                
                if locationModelData.state.days.count > 0 {
                    /// Buttons for Select Date
                    self.btnRightDate.hidden = false
                    self.btnLeftDate.hidden = false
                    if index == 0 {
                        self.btnRightDate.hidden = true
                    }
                    if index >= (locationModelData.state.days.count - 1) {
                        self.btnLeftDate.hidden = true
                    }
                    
                    self.lblTitle.text = dateString(locationModelData.state.days[index])
                    
                } else {
                    
                    self.lblTitle.text = "Today"
                    
                }
                
//                self.delegate?.alertSelectedDayIndex(index)
            }
        }
        
    }

    internal func dateString(dateString: String) -> String {
        let todayString = DATE_FORMATTER.Default.stringFromDate(NSDate())
        if dateString == todayString {
            return "Today"
        } else {
            return dateString
        }
    }
    
    func selectHealthCategory(typeIndex: Int) -> Void {
        
    }
    
}

protocol BE24AlertHeaderCellDelegate {

    func alertSelectedWeekDayType(type: AlertType) -> Void

    func alertSelectedDayStep(step: Int) -> Void
    
}
