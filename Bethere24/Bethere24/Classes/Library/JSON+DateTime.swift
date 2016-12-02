//
//  JSON+DateTime.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/27/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public func dateFromFormat(dateFormat: String = "yyyy-MM-dd") -> NSDate? {
        switch self.type {
        case .String:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            let date = dateFormatter.dateFromString(self.object as! String)
            return date
        default:
            return nil
        }
    }
    
    public func dateTime() -> NSDate? {
        return dateFromFormat("yyyy-MM-dd'T'HH:mm:ss")
    }
}