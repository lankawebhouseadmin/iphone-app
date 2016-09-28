//
//  JSON+DateTime.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/27/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public func dateFromFormat(dateFormat: String = "yyyy-MM-dd") -> NSDate? {
        switch self.type {
        case .String:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.dateFromString(self.object as! String)
        default:
            return nil
        }
    }
    
    public func dateTime() -> NSDate? {
        return dateFromFormat("yyyy'-'MM'-'dd'T'hh':'mm':'ss")
    }
}