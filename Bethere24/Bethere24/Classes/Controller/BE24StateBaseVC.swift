//
//  BE24StateBaseVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/7/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

class BE24StateBaseVC: BE24MainBaseVC {

    internal var statesData: BE24LocationModel?
    internal var stateDataOfCurrentDay: [BE24StateModel]?

    internal var healthTypeForIndex: [HealthType] = [
        .InBathroom,
        .WithVisitors,
        .InDining,
        .InMotion,
        .InBedroom,
        .AwayFromHome,
        .InRecliner,
        .TakingMedication,
        ]

    internal let healthDetailReportTemplete: [HealthType: [String]] = [
        HealthType.InBedroom : [
            "had a good night sleep",
            "may not have slept well",
            "had difficulty sleeping",
        ],
        HealthType.InRecliner : [
            "used the recliner normally",
            "may not have used the recliner normally",
            "had some difficulty using the recliner",
        ],
        HealthType.InDining : [
            "had eat normally",
            "may not have eaten well",
            "did not eat well",
        ],
        HealthType.InBathroom : [
            "used the bathroom normally",
            "may have had difficulty in the bathroom",
            "had difficulty in the bathroom",
        ],
        HealthType.TakingMedication : [
            "took medication as expected",
            "may not have taken medication as expected",
            "did not take medication as expected",
        ],
        HealthType.AwayFromHome : [
            "spent time out of the house",
            "spent time out of the house",
            "spent time out of the house",
        ],
        HealthType.WithVisitors : [
            "had visitors",
            "had visitors",
            "had visitors",
        ],
        HealthType.InMotion : [
            "",
            "",
            "",
        ]
    ]
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        if appManager().stateData != nil {
            if appManager().stateData!.count > 0 {
                statesData = appManager().stateData!.first!
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func dateString(dateString: String) -> String {
        if appManager().currentUser == nil {
            return dateString
        } else {
            let todayString = BE24AppManager.defaultDayString(appManager().currentUser!.loginTime!) //  DATE_FORMATTER.Default.stringFromDate(NSDate())
            if dateString == todayString {
                return "Today"
            } else {
                return dateString
            }
        }
    }
    
    internal func timeString(totalTimes: Int, isMedication: Bool = false) -> String {
        if isMedication == false {
            let hour = totalTimes / 60
            let minute = totalTimes % 60
            if hour > 0 {
                var timeString = "\(hour) Hr"
                if minute > 0 {
                    timeString = timeString + " \(minute) Min"
                }
                return timeString
            } else {
                return "\(minute) Min"
            }
        } else {
            if totalTimes > 1 {
                return "\(totalTimes) times"
            } else {
                return "\(totalTimes) time"
            }
        }
    }
    
    internal func healthDetailReportString(type: HealthType, score: Int) -> String {
        if appManager().currentUser != nil {
            let fullname = appManager().currentUser!.firstName! // appManager().currentUser!.fullname()
            var index: Int = 0
            if 3 <= score && score < 8 {
                index = 1
            } else if score < 3 {
                index = 2
            }
            let reportString = fullname + " " + healthDetailReportTemplete[type]![index] + "."
            return reportString
        } else {
            return ""
        }
    }
    
    override func refreshData() {
        super.refreshData()
        
        statesData = nil
        if appManager().stateData != nil {
            if appManager().stateData!.count > 0 {
                statesData = appManager().stateData!.first!
            }
        }
        
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
