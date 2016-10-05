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
    
    var delegate: BE24AlertHeaderCellDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private func setAlertType(type: AlertType) {
        alertType = type
        if alertType == .Week {
            self.btnLeftDate.hidden = true
            self.btnRightDate.hidden = true
            self.imgviewHealthCategory.image = nil
            self.lblTitle.text = "All"
        } else {
            self.btnLeftDate.hidden = false
            self.btnRightDate.hidden = false
            self.imgviewHealthCategory.image = nil
            self.lblTitle.text = "10/4 - Tue."
        }
    }
    
    func selectHealthCategory(typeIndex: Int) -> Void {
        
    }
    
    @IBAction func onPressChangeWeekDayType(sender: AnyObject) {
        if self.segmentType.selectedSegmentIndex == 0 {
            setAlertType(.Day)
            self.delegate?.alertSelectedWeekDayType(.Day)
        } else {
            setAlertType(.Week)
            self.delegate?.alertSelectedWeekDayType(.Week)
        }
    }
    
    @IBAction func onPressLeftDate(sender: AnyObject) {
        self.lblTitle.text = self.delegate?.alertSelectedLeftDate()
    }
    
    @IBAction func onPressRightDate(sender: AnyObject) {
        self.lblTitle.text = self.delegate?.alertSelectedRightDate()
    }
    
}

protocol BE24AlertHeaderCellDelegate {
    func alertSelectedWeekDayType(type: AlertType) -> Void
    func alertSelectedHealthTypeIndex(index: Int)  -> Void
    func alertSelectedLeftDate() -> String
    func alertSelectedRightDate() -> String
}
