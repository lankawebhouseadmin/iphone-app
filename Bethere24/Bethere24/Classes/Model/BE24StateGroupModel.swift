//
//  BE24StateGroupModel.swift
//  Bethere24
//
//  Created by Prbath Neranja on 10/7/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SwiftyJSON

class BE24StateGroupModel: BE24Model {
    
    private var data: [String: AnyObject] = [:]
    private var allStates: [BE24StateModel] = []
    
    /// App side data
    var days            : [String] = []
    var statesByDay     : [String: [BE24StateModel]] = [:]
    var statesByType    : [HealthType: AnyObject] = [:]

    override init(data: JSON) {
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
        types.forEach { (type: HealthType) in
            if let states = data[type.rawValue].array {
                var arrayStates: [BE24StateModel] = []
                states.forEach({ (elem: JSON) in
                    let aState = BE24StateModel(data: elem)
                    arrayStates.append(aState)
                    self.allStates.append(aState)
                })
                self.setStates(arrayStates, forType: type)
            }
        }
        
        branchState()
    }
    
    func setObject(object: AnyObject, key: String) -> Void {
        data[key] = object
    }
    
    func objectForKey(key: String) -> AnyObject? {
        return data[key]
    }
    
    func setStates(states: [BE24StateModel], forType: HealthType) -> Void {
        self.setObject(states, key: forType.rawValue)
    }
    
    func statesForType(type: HealthType) -> [BE24StateModel]? {
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
    
    private func branchState() -> Void {
        
        allStates.sortInPlace { (first: BE24StateModel, second: BE24StateModel) -> Bool in
            if first.startTime.compare(second.startTime) == .OrderedAscending {
                return false
            } else {
                return true
            }
        }
        
        allStates.forEach { (aState: BE24StateModel) in
            
            let dateString = aState.dateString()
            if days.contains(dateString) == false {
                days.append(dateString)
            }
            
            var statesForDate = statesByDay[dateString]
            if statesForDate == nil {
                statesForDate = []
            }
            statesForDate!.append(aState)
            statesByDay[dateString] = statesForDate!
        }
        
//        print(days.count)
        
    }

    
}
