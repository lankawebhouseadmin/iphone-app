//
//  BE24AlertHeaderCell.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/5/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

enum AlertType {
    case week
    case day
}

class BE24AlertHeaderCell: BE24TableViewCell {

    class func cellIdentifier() -> String {
        return "BE24AlertHeaderCell"
    }
    
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var btnLeftDate: UIButton!
    @IBOutlet weak var btnRightDate: UIButton!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var imgviewHealthCategory: UIImageView!
    @IBOutlet weak var btnHealthType: UIButton!
    
    var alertType: AlertType = .week
    
    fileprivate var _currentDateIndex: Int = 0
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
        self.btnLeftDate.isHidden = true
        self.btnRightDate.isHidden = true
//        self.lblTitle.text = "All"
        self.btnHealthType.setImage(nil, for: UIControlState())
        self.btnHealthType.setTitle("All", for: UIControlState())
    }
    
    @IBAction func onPressChangeWeekDayType(_ sender: AnyObject) {
        
        if self.segmentType.selectedSegmentIndex == 0 {
            self.delegate?.alertSelectedWeekDayType(.day)
//            setAlertType(.Day)
            //            self.delegate?.alertSelectedWeekDayType(.Day)
        } else {
            self.delegate?.alertSelectedWeekDayType(.week)
//            setAlertType(.Week)
            //            self.delegate?.alertSelectedWeekDayType(.Week)
        }
    }
    
    @IBAction func onPressHealthType(_ sender: AnyObject) {
        delegate?.alertChooseHealthType()
    }
    
    @IBAction func onPressLeftDate(_ sender: AnyObject) {
//        currentDateIndex += 1
//        selectDateIndex(currentDateIndex)
        self.delegate?.alertSelectedDayStep(-1)
    }
    
    @IBAction func onPressRightDate(_ sender: AnyObject) {
//        currentDateIndex -= 1
//        selectDateIndex(currentDateIndex)
        self.delegate?.alertSelectedDayStep(1)
    }
    

    fileprivate func setAlertType(_ type: AlertType) {
        alertType = type
        if alertType == .week {
            self.btnLeftDate.isHidden = true
            self.btnRightDate.isHidden = true
//            self.imgviewHealthCategory.image = nil
//            self.lblTitle.text = "All"
            self.btnHealthType.setImage(nil, for: UIControlState())
            self.btnHealthType.setTitle("All", for: UIControlState())
//            self.delegate?.alertSelectedDayIndex(nil)
            self.btnHealthType.isEnabled = true
        } else {
            self.btnLeftDate.isHidden = false
            self.btnRightDate.isHidden = false
//            self.imgviewHealthCategory.image = nil
            self.btnHealthType.setImage(nil, for: UIControlState())
//            self.lblTitle.text = "10/4 - Tue."
            
//            self.delegate?.alertSelectedDayIndex(currentDateIndex)
            self.btnHealthType.isEnabled = false
        }
    }
    
    internal func selectDateIndex(_ index: Int) {
        
        if let stateData = BE24AppManager.sharedManager.stateData {
            if stateData.count > 0 {
                
                let locationModelData = stateData.first!
                
                if locationModelData.state.days.count > 0 {
                    /// Buttons for Select Date
                    self.btnRightDate.isHidden = false
                    self.btnLeftDate.isHidden = false
                    if index == 0 {
                        self.btnRightDate.isHidden = true
                    }
                    if index >= (locationModelData.state.days.count - 1) {
                        self.btnLeftDate.isHidden = true
                    }
                    
//                    self.lblTitle.text = dateString(locationModelData.state.days[index])
                    self.btnHealthType.setTitle(dateString(locationModelData.state.days[index]), for: UIControlState())
                    
                } else {
                    
//                    self.lblTitle.text = "Today"
                    self.btnHealthType.setTitle("Today", for: UIControlState())
                    
                }
                
//                self.delegate?.alertSelectedDayIndex(index)
            }
        }
        
    }

    internal func dateString(_ dateString: String) -> String {
        let todayString = DATE_FORMATTER.Default.string(from: Date())
        if dateString == todayString {
            return "Today"
        } else {
            return dateString
        }
    }
    
    func selectHealthCategory(_ typeIndex: Int) -> Void {
        
    }
    
}

protocol BE24AlertHeaderCellDelegate {

    func alertSelectedWeekDayType(_ type: AlertType) -> Void

    func alertSelectedDayStep(_ step: Int) -> Void
    
    func alertChooseHealthType() -> Void
    
}
