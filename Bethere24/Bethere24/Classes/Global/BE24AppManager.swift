//
//  BE24AppManager.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

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
    
    var menuItems: [[String: String]] = {
        var _menuItems = [
            [
                kMenuIconKeyName : "iconMenuHeart",
                kMenuTitleKeyName : "Health Summary",
                kMenuSegueKeyName : APPSEGUE_gotoHealthSummaryVC
            ],
            [
                kMenuIconKeyName : "iconMenuHealth",
                kMenuTitleKeyName : "Health Score Details",
                kMenuSegueKeyName : APPSEGUE_gotoHealthScoreVC
            ],
            [
                kMenuIconKeyName : "iconMenuAlert",
                kMenuTitleKeyName : "Alert Summary",
                kMenuSegueKeyName : APPSEGUE_gotoAlertSummaryVC
            ],
            [
                kMenuIconKeyName : "iconMenuGraph",
                kMenuTitleKeyName : "Historical Graphs",
                kMenuSegueKeyName : APPSEGUE_gotoHistoricalGraphsVC
            ],
            [
                kMenuIconKeyName : "iconMenuContact",
                kMenuTitleKeyName : "Contact Information",
                kMenuSegueKeyName : APPSEGUE_gotoContactInfoVC
            ],
            
            ]
        return _menuItems
    }()
    
    var token: String?
    var currentUser: BE24UserModel?

}

enum PageType {
    case HealthSummary
    case HealthScoreDetails
    case AlertSummary
    case HistoricalGraphs
    case ContactInfo
    case None
}

struct APPCOLOR {
    static let BACKGROUND_BLACK = UIColor(colorLiteralRed: 0.145, green: 0.145, blue: 0.145, alpha: 1)
    static let TEXTCOLOR_DARK   = UIColor(colorLiteralRed: 0.588, green: 0.588, blue: 0.588, alpha: 1)
    
}

let kMenuIconKeyName            = "icon"
let kMenuTitleKeyName           = "name"
let kMenuSegueKeyName           = "segue"

let APPSEGUE_gotoMainVC             = "gotoMainVC"
let APPSEGUE_gotoMenuVC             = "gotoMenuVC"
let APPSEGUE_gotoHealthSummaryVC    = "gotoHealthSummary"
let APPSEGUE_gotoHealthScoreVC      = "gotoHealthScoreVC"
let APPSEGUE_gotoAlertSummaryVC     = "gotoAlertSummaryVC"
let APPSEGUE_gotoHistoricalGraphsVC = "gototHistoricalGraphsVC"
let APPSEGUE_gotoContactInfoVC      = "gotoContactInfoVC"
