//
//  BE24HealthBaseVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/29/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

class BE24HealthBaseVC: BE24StateBaseVC {

    @IBOutlet weak var lblDate                  : UILabel?
    @IBOutlet weak var lblHealthTitle           : UILabel!
    @IBOutlet weak var lblTimes                 : UILabel!
    @IBOutlet weak var lblAlerts                : UILabel?
    @IBOutlet weak var lblHealthDetail          : UILabel!
    @IBOutlet weak var viewDetailBox            : UIView?
    @IBOutlet weak var imgHealthIcon            : UIImageView!
    @IBOutlet weak var btnLeftDate              : UIButton?
    @IBOutlet weak var btnRightDate             : UIButton?
    @IBOutlet weak var btnLeftHealthCategory    : UIButton!
    @IBOutlet weak var btnRightHealthCategory   : UIButton!
    @IBOutlet weak var btnAlert                 : UIButton!
    
    @IBOutlet weak var constraintLeftOfFirstButton:  NSLayoutConstraint!
    @IBOutlet weak var constraintHSpaceOfLastButton: NSLayoutConstraint!

    internal var currentDateIndex: Int = 0
    internal var selectedHealthType: HealthType = .InBathroom

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectDateIndex(currentDateIndex)
    }

    override func setupLayout() {
        super.setupLayout()
        
        self.viewDetailBox?.makeRoundView(radius: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func graphCellIndex() -> Int {
        return 100
    }

    // MARK:
    internal func selectDateIndex(index: Int) {
        if statesData != nil {
            
            
            if statesData!.state.days.count > index {
                currentDateIndex = index
                let dayString = statesData!.state.days[index]
                
                /// Buttons for Select Date
                self.btnRightDate?.hidden = false
                self.btnLeftDate?.hidden = false
                if index == 0 {
                    self.btnRightDate?.hidden = true
                }
                if index >= (statesData!.state.days.count - 1) {
                    self.btnLeftDate?.hidden = true
                }
                
                self.lblDate?.text = dateString(dayString)
                
                if let alerts = statesData!.alert {
                    var alertCountForDay: Int = 0
                    for alert in alerts {
                        if alert.dateString(statesData!.clientInfo.virtualDayStartOriginal) == dayString {
                            alertCountForDay += 1
                        }
                    }
                    updateAlertBadgeCount(alertCountForDay)
                }

            } else {
                
                self.lblDate?.text = "Today"
                
            }
            
            
        }
        
    }
    
    internal func showAlertCount() {
        
        if statesData!.state.days.count > currentDateIndex {
            let dayString = statesData!.state.days[currentDateIndex]
            if let alerts = statesData!.alert {
                var alertsForCurrentHealthType: [BE24AlertModel] = []
                for alert in alerts {
                    if alert.dateString(statesData!.clientInfo.virtualDayStartOriginal) == dayString &&
                        selectedHealthType == alert.type() {
                        alertsForCurrentHealthType.append(alert)
                    }
                }
                if alertsForCurrentHealthType.count > 0 {
                    if self.lblAlerts != nil {
                        var alertCountString = "1 Alert"
                        if alertsForCurrentHealthType.count > 1 {
                            alertCountString = String(alertsForCurrentHealthType.count) + " Alerts"
                        }
                        self.lblAlerts!.text = alertCountString
                    }
                    self.constraintLeftOfFirstButton.constant = -55
                    self.constraintHSpaceOfLastButton.constant = 80
                    self.btnAlert.hidden = false
                } else {
                    self.lblAlerts?.text = nil
                    self.constraintLeftOfFirstButton.constant = -25
                    self.constraintHSpaceOfLastButton.constant = 25
                    self.btnAlert.hidden = true
                }
            } else {
                self.lblAlerts?.text = nil
                self.constraintLeftOfFirstButton.constant = -25
                self.constraintHSpaceOfLastButton.constant = 25
                self.btnAlert.hidden = true
            }
        }
    }
    
    @IBAction func onPressLeftDate(sender: AnyObject) {
        currentDateIndex += 1
        selectDateIndex(currentDateIndex)
    }
    
    @IBAction func onPressRightDate(sender: AnyObject) {
        currentDateIndex -= 1
        selectDateIndex(currentDateIndex)
    }
    
    @IBAction func onPressHistoricalGraphsAndAlert(sender: AnyObject) {
        appManager().selectedHealthType = selectedHealthType
        appManager().selectedDayIndex   = currentDateIndex
        appManager().prevVCForAlertVC   = self
        
        if sender as? UIButton == self.btnAlert {
            sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoAlertSummaryVC, sender: self)
        } else {
            sideMenuController?.performSegueWithIdentifier(APPSEGUE_gotoHistoricalGraphsVC, sender: self)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? BE24NavigationController {
            if let alertVC = navVC.topViewController as? BE24AlertSummaryVC {
                alertVC.prevVC = self
            }
        }
    }
    */

}
