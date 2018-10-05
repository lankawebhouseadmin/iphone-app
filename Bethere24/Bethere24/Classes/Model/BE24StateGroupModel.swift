//
//  BE24StateGroupModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/7/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24StateGroupModel: BE24Model {
    
    fileprivate var data: [String: AnyObject] = [:]
    fileprivate var allStates: [BE24StateModel] = []
    
    /// App side data
    var days            : [String] = []
    var statesByDay     : [String: [BE24StateModel]] = [:]
    var statesByType    : [HealthType: AnyObject] = [:]

    init(data: JSON, virtualTime: String) {
        super.init(data: data)
        let types: [HealthType] = [
                .InBathroom,
                .WithVisitors,
                .InDining,
                .InMotion,
                .InBedroom,
                .AwayFromHome,
                .InRecliner,
                .TakingMedication,
            ]
        for type in types {
            if let states = data[type.rawValue].array {
                var arrayStates: [BE24StateModel] = []
                for elem in states {
                    let aState = BE24StateModel(data: elem)
                    aState.setVirtualDayTime(virtualTime)
                    arrayStates.append(aState)
                    self.allStates.append(aState)
                }
                self.setStates(arrayStates, forType: type)
            }
        }
        
        branchState(virtualTime)
    }
    
    func setObject(_ object: AnyObject, key: String) -> Void {
        data[key] = object
    }
    
    func objectForKey(_ key: String) -> AnyObject? {
        return data[key]
    }
    
    func setStates(_ states: [BE24StateModel], forType: HealthType) -> Void {
        self.setObject(states as AnyObject, key: forType.rawValue)
    }
    
    func statesForType(_ type: HealthType) -> [BE24StateModel]? {
        if let statesObject = data[type.rawValue] {
            if let states = statesObject as? [BE24StateModel] {
                return states
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    fileprivate func branchState(_ virtualTime: String) -> Void {
        
        allStates.sort { (first: BE24StateModel, second: BE24StateModel) -> Bool in
            if first.startTime.compare(second.startTime as Date) == .orderedAscending {
                return false
            } else {
                return true
            }
        }
        
        var startDayTimeInterval: Double = 2000000000
        var endDayTimeInterval: Double = Date().timeIntervalSince1970
        
        let virtualElems = virtualTime.components(separatedBy: ":")
        let virtualSeconds = Double(virtualElems[0])! * 3600 + Double(virtualElems[1])! * 60 + Double(virtualElems[2])!
        
        endDayTimeInterval -= virtualSeconds
        
        for aState in allStates {
            let dateString = aState.dateString(virtualTime)
//            let timeInterval = aState.startTime.timeIntervalSince1970
            let timeInterval = aState.startTime.timeIntervalSince1970 //DATE_FORMATTER.Default.dateFromString(dateString)!.timeIntervalSince1970
            if startDayTimeInterval > timeInterval {
                startDayTimeInterval = timeInterval
            }
//            if endDayTimeInterval < timeInterval {
//                endDayTimeInterval = timeInterval
//            }
            
            var statesForDate = statesByDay[dateString]
            if statesForDate == nil {
                statesForDate = []
            }
            statesForDate!.append(aState)
            statesByDay[dateString] = statesForDate!
        }
        
        days.removeAll()
        var timeInterval = endDayTimeInterval
        while timeInterval > startDayTimeInterval - (3600 * 24) {
            let dateString = DATE_FORMATTER.Default.string(from: Date(timeIntervalSince1970: timeInterval))
            days.append(dateString)
            
            var statesForDate = statesByDay[dateString]
            if statesForDate == nil {
                statesForDate = []
                statesByDay[dateString] = statesForDate!
            }
            
            timeInterval -= (3600 * 24)
        }
        
        
        print(days.count)
        
    }

    
}
