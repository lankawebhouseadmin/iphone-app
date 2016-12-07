//
//  BE24AppManager.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class BE24AppManager: NSObject {

    class var sharedManager: BE24AppManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BE24AppManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BE24AppManager()
        }
        return Static.instance!
    }
    
    let menuItems: [[String: String]] = {
        var _menuItems = [
            [
                kMenuIconKeyName  : "iconMenuHeart",
                kMenuTitleKeyName : "Health Summary",
                kMenuSegueKeyName : APPSEGUE_gotoHealthSummaryVC
            ],
            [
                kMenuIconKeyName  : "iconMenuHealth",
                kMenuTitleKeyName : "Health Score Details",
                kMenuSegueKeyName : APPSEGUE_gotoHealthScoreVC
            ],
            [
                kMenuIconKeyName  : "iconMenuAlert",
                kMenuTitleKeyName : "Alert Summary",
                kMenuSegueKeyName : APPSEGUE_gotoAlertSummaryVC
            ],
            [
                kMenuIconKeyName  : "iconMenuGraph",
                kMenuTitleKeyName : "Historical Graphs",
                kMenuSegueKeyName : APPSEGUE_gotoHistoricalGraphsVC
            ],
            [
                kMenuIconKeyName  : "iconMenuContact",
                kMenuTitleKeyName : "Contact Information",
                kMenuSegueKeyName : APPSEGUE_gotoContactInfoVC
            ],
            
            ]
        return _menuItems
    }()
    
    let categories: [[String: String]] = {
        let _categories = [
            [
                kMenuTitleKeyName : "In Bathroom",
                kMenuIconKeyName  : "iconInBathroom",
                kMenuColorKeyName : "#0246ff",
            ],
            [
                kMenuTitleKeyName : "With Visitors",
                kMenuIconKeyName  : "iconWithVisitors",
                kMenuColorKeyName : "#0290ce",
            ],
            [
                kMenuTitleKeyName : "In Dining Area",
                kMenuIconKeyName  : "iconInDiningArea",
                kMenuColorKeyName : "#2d6f00",
            ],
            [
                kMenuTitleKeyName : "In Motion",
                kMenuIconKeyName  : "iconInMotion",
                kMenuColorKeyName : "#aaac00",
            ],
            [
                kMenuTitleKeyName : "In Bedroom",
                kMenuIconKeyName  : "iconInBedroom",
                kMenuColorKeyName : "#9b5d00",
            ],
            [
                kMenuTitleKeyName : "Away From Home",
                kMenuIconKeyName  : "iconAwayFromHome",
                kMenuColorKeyName : "#da521d",
            ],
            [
                kMenuTitleKeyName : "In Recliner",
                kMenuIconKeyName  : "iconInRecliner",
                kMenuColorKeyName : "#ba2a5c",
            ],
            [
                kMenuTitleKeyName : "Taking Medication",
                kMenuIconKeyName  : "iconTakingMedication",
                kMenuColorKeyName : "#3d00a3",
            ],
        ]
        return _categories
    }()
    
    let healthTypeForIndex: [HealthType] = [
        .InBathroom,
        .WithVisitors,
        .InDining,
        .InMotion,
        .InBedroom,
        .AwayFromHome,
        .InRecliner,
        .TakingMedication,
        ]
    
    var token: String?
    var currentUser: BE24UserModel?
    var stateData : [BE24LocationModel]? {
        didSet {
            
        }
    }
    
    var selectedHealthType: HealthType?
    var selectedDayIndex: Int?
    var prevVCForAlertVC: BE24HealthBaseVC?
    
    private func analyticsData() {
        
    }
    
    class func colorForScore(score: Int) -> UIColor {
        var colorValueIndex = 0
        if 2 < score && score <= 7 {
            colorValueIndex = 1
        } else if 7 < score {
            colorValueIndex = 2
        }
        let stateColor = [
            "#ff0000",
            "#ffc800",
            "#68ff00",
            ]
        let colorValue = stateColor[colorValueIndex]
        return UIColor(rgba: colorValue)
    }
    
    func saveUsername(username: String, password: String) {
        let userDefault = NSUserDefaults.standardUserDefaults();
        userDefault.setObject(username, forKey: "username")
        userDefault.setObject(password, forKey: "password")
        userDefault.synchronize()
    }
    
    func getUsernamePassword() -> (String?, String?) {
        let userDefault = NSUserDefaults.standardUserDefaults();
        let username: String? = userDefault.objectForKey("username") as? String
        let password: String? = userDefault.objectForKey("password") as? String
        return (username, password)
    }
    
}

enum PageType {
    case HealthSummary
    case HealthScoreDetails
    case AlertSummary
    case HistoricalGraphs
    case ContactInfo
    case None
}

enum HealthType: String {
    case InBathroom         = "in_bathroom"
    case WithVisitors       = "with_visitors"
    case InDining           = "in_dining"
    case InMotion           = "in_motion"
    case InBedroom          = "sleeping"
    case AwayFromHome       = "away_from_home"
    case InRecliner         = "in_recliner"
    case TakingMedication   = "medication"
    case Other              = "other"
}

struct APPCOLOR {
    static let BACKGROUND_BLACK = UIColor(colorLiteralRed: 0.145, green: 0.145, blue: 0.145, alpha: 1)
    static let TEXTCOLOR_DARK   = UIColor(colorLiteralRed: 0.588, green: 0.588, blue: 0.588, alpha: 1)
    static let InBathroom       = UIColor(rgba: "#0246ff")
    static let WithVisitors     = UIColor(rgba: "#0290ce")
    static let InDiningArea     = UIColor(rgba: "#2d6f00")
    static let InMotion         = UIColor(rgba: "#aaac00")
    static let InBedroom        = UIColor(rgba: "#9b5d00")
    static let AwayFromHome     = UIColor(rgba: "#da521d")
    static let InRecliner       = UIColor(rgba: "#ba2a5c")
    static let TakingMedication = UIColor(rgba: "#3d00a3")
}

struct DATE_FORMATTER {
    static let Default: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d - eee."
        return dateFormatter
    }()
    static let ForAlert: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy\nh:m a"
        return dateFormatter
    }()
    static let MonthDay: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    static let OnlyTime: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter
    }()
    static let TimeA: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    static let StandardISO: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        return dateFormatter
    }()
}

let kMenuIconKeyName            = "icon"
let kMenuTitleKeyName           = "name"
let kMenuSegueKeyName           = "segue"
let kMenuColorKeyName           = "color"

let APPSEGUE_gotoMainVC             = "gotoMainVC"
let APPSEGUE_gotoMenuVC             = "gotoMenuVC"
let APPSEGUE_gotoHealthSummaryVC    = "gotoHealthSummary"
let APPSEGUE_gotoHealthScoreVC      = "gotoHealthScoreVC"
let APPSEGUE_gotoAlertSummaryVC     = "gotoAlertSummaryVC"
let APPSEGUE_gotoHistoricalGraphsVC = "gototHistoricalGraphsVC"
let APPSEGUE_gotoContactInfoVC      = "gotoContactInfoVC"

let NOTIFICACTION_EnterBackground   = "com.bethere24.enter.background.app"
