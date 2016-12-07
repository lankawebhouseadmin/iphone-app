//
//  BE24RequestManager.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BE24RequestManager: NSObject {

    class var sharedManager: BE24RequestManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BE24RequestManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BE24RequestManager()
        }
        return Static.instance!
    }
    
    typealias DetailtResponse = (AnyObject?, NSError?) -> Void
    
//    let baseURL = "http://staging.noostore.com"
    static var baseURL = "http://uat.noostore.com:80"
    let URI_Login = "/api/login/"
    let UIR_State = "/api/states/"
    func POST(url: String, params: [String: AnyObject]?, result: DetailtResponse) -> Void {
        Alamofire.request(.POST, url, parameters: params).responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let userData):
                result(userData, nil)
                break
            case .Failure(let error):
                result(nil, error)
                break
            }
        }
    }
    
    func GET(url: String, params: [String: AnyObject]?, result: DetailtResponse) -> Void {
        Alamofire.request(.GET, url, parameters: params).responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let userData):
                result(userData, nil)
                break
            case .Failure(let error):
                result(nil, error)
                break
            }
        }
    }
    
    func requestURL(uri: String) -> String {
        
        return BE24RequestManager.baseURL + uri
    }

    func login(username: String, password: String, result: DetailtResponse) -> Void {
        
        let url = requestURL(URI_Login)
        let params = [
            "username": username,
            "password": password
        ]
        POST(url, params: params, result: result)
        
    }
    
    func getData(userid: Int, token: String, result: (([BE24LocationModel]?, JSON?, NSError?) -> Void)) -> Void {
        let url = requestURL(UIR_State + String(userid) + "/" + token)
        GET(url, params: nil) { (response: AnyObject?, error: NSError?) in
            if response != nil {
                let json = JSON(response!)
                var locations: [BE24LocationModel] = []
                if json.arrayValue.count > 0 {
                    let location = json.arrayValue.first!["location"]["0"]
                    locations.append(BE24LocationModel(data: location))
                }
                result(locations, json, nil)
            } else {
                result(nil, nil, error)
            }
        }
    }
    
//    private func GET(url: String, params: [String: AnyObject], response:Response<AnyObject, NSError>) {
//        Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: nil).responseJSON(response)
//        
//    }
    
}
