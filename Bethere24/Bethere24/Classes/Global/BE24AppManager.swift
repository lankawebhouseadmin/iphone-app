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

//    private static var __once: () = {
//            let shared = BE24AppManager()
//        }()
//
//    class var sharedManager: BE24AppManager {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: BE24AppManager? = nil
//        }
//        _ = BE24AppManager.__once
//        return Static.instance!
//    }
    
    static let sharedManager = BE24AppManager()
    
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
            [
                kMenuIconKeyName  : "iconMenuLogout",
                kMenuTitleKeyName : "LogOut",
                kMenuSegueKeyName : APPSEGUE_gotoLoginForLogout
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
    
    fileprivate func analyticsData() {
        
    }
    
    class func colorForScore(_ score: Int) -> UIColor {
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
        return colorWithHexString(hexString: colorValue)
    }
    
    class func defaultDayString(_ date: Date) -> String {
        if BE24AppManager.sharedManager.currentUser == nil {
            return DATE_FORMATTER.Default.string(from: date)
        } else {
            let virtualTime = BE24AppManager.sharedManager.stateData!.first!.clientInfo.virtualDayStartOriginal
            let timeString = DATE_FORMATTER.OnlyTime.string(from: date)
            let elems = timeString.components(separatedBy: ":")
            let timeSeconds = Int(elems[0])! * 3600 + Int(elems[1])! * 60 + Int(elems[2])!
            let virtualElems = virtualTime.components(separatedBy: ":")
            let virtualSeconds = Int(virtualElems[0])! * 3600 + Int(virtualElems[1])! * 60 + Int(virtualElems[2])!
            if timeSeconds > virtualSeconds {
                return DATE_FORMATTER.Default.string(from: date)
            } else {
                return DATE_FORMATTER.Default.string(from: Date(timeIntervalSince1970: date.timeIntervalSince1970 - Double(virtualSeconds)))
            }
        }
    }
    
    func saveUsername(_ username: String, password: String) {
        let userDefault = UserDefaults.standard;
        userDefault.set(username, forKey: "username")
        userDefault.set(password, forKey: "password")
        userDefault.synchronize()
    }
    
    func getUsernamePassword() -> (String?, String?) {
        let userDefault = UserDefaults.standard;
        let username: String? = userDefault.object(forKey: "username") as? String
        let password: String? = userDefault.object(forKey: "password") as? String
        return (username, password)
    }
    
}

enum PageType {
    case healthSummary
    case healthScoreDetails
    case alertSummary
    case historicalGraphs
    case contactInfo
    case none
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
//    static let BACKGROUND_BLACK = UIColor(colorLiteralRed: 0.145, green: 0.145, blue: 0.145, alpha: 1)
    static let BACKGROUND_BLACK = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1.0)
    
    static let TEXTCOLOR_DARK   = colorWithHexString(hexString: "#222222")
    static let InBathroom       = colorWithHexString(hexString: "#0246ff")
    static let WithVisitors     = colorWithHexString(hexString: "#0290ce")
    static let InDiningArea     = colorWithHexString(hexString: "#2d6f00")
    static let InMotion         = colorWithHexString(hexString: "#aaac00")
    static let InBedroom        = colorWithHexString(hexString: "#9b5d00")
    static let AwayFromHome     = colorWithHexString(hexString: "#da521d")
    static let InRecliner       = colorWithHexString(hexString: "#ba2a5c")
    static let TakingMedication = colorWithHexString(hexString: "#3d00a3")
}

struct DATE_FORMATTER {
    static let Default: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d - eee."
        return dateFormatter
    }()
    static let ForAlert: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy\nh:mm a"
        return dateFormatter
    }()
    static let MonthDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter
    }()
    static let OnlyTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter
    }()
    static let TimeA: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    static let StandardISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        return dateFormatter
    }()
    static let FullDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d - eee. hh:mm:ss"
        return dateFormatter
    }()
}


func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
    
    // Convert hex string to an integer
    let hexint = Int(intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    let alpha = alpha!
    
    // Create color object, specifying alpha as well
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return color
}

func intFromHexString(hexStr: String) -> UInt32 {
    var hexInt: UInt32 = 0
    // Create scanner
    let scanner: Scanner = Scanner(string: hexStr)
    // Tell scanner to skip the # character
    scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
    // Scan hex value
    scanner.scanHexInt32(&hexInt)
    return hexInt
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
let APPSEGUE_gotoLoginForLogout      = "LoginVC"
let APPSEGUE_gotoContactInfoVC      = "gotoContactInfoVC"

let NOTIFICACTION_EnterBackground   = "com.bethere24.enter.background.app"
