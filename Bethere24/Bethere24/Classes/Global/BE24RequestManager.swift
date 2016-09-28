//
//  BE24RequestManager.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import Alamofire

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
    
    typealias DefailtResponse = (AnyObject?, NSError?) -> Void
    
    let baseURL = "http://staging.noostore.com"
    let URI_Login = "/api/login/"
    
    
    func login(username: String, password: String, result: DefailtResponse) -> Void {
        
        let url = requestURL(URI_Login)
        let params = [
            "username": username,
            "password": password
        ]
        POST(url, params: params, result: result)
        
    }
    
    func POST(url: String, params: [String: AnyObject]?, result: DefailtResponse) -> Void {
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
    
    func GET(url: String, params: [String: AnyObject]?, result: DefailtResponse) -> Void {
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
        return baseURL + uri
    }
//    private func GET(url: String, params: [String: AnyObject], response:Response<AnyObject, NSError>) {
//        Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: nil).responseJSON(response)
//        
//    }
    
}
