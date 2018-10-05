//
//  JSON+DateTime.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/27/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import SwiftyJSON

extension JSON {
    
    public func dateFromFormat(_ dateFormat: String = "yyyy-MM-dd") -> Date? {
        switch self.type {
        case .string:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let date = dateFormatter.date(from: self.object as! String)
            return date
        default:
            return nil
        }
    }
    
    public func dateTime() -> Date? {
        return dateFromFormat("yyyy-MM-dd'T'HH:mm:ss")
    }
}
