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

//    private static var __once: () = {
//            Static.instance = BE24RequestManager()
//        }()
//
//    class var sharedManager: BE24RequestManager {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: BE24RequestManager? = nil
//        }
//        _ = BE24RequestManager.__once
//        return Static.instance!
//    }
    
    static let sharedManager = BE24RequestManager()
    
    typealias DetailtResponse = (AnyObject?, NSError?) -> Void
    
    static var baseURL = "http://uat.bt24go.com"
        let URI_Login = "/api/login/"
        let UIR_State = "/api/utc_states/"
    func POST(_ url: String, params: [String: AnyObject]?, result: @escaping DetailtResponse) -> Void {
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let userData):
                result(userData as AnyObject, nil)
                break
            case .failure(let error):
                result(nil, error as NSError)
                break
            }
        }
        
        
//        Alamofire.request(.POST, url, parameters: params).responseJSON { (response: Response<AnyObject, NSError>) in
//            switch response.result {
//            case .Success(let userData):
//                result(userData, nil)
//                break
//            case .Failure(let error):
//                result(nil, error)
//                break
//            }
//        }
    }
    
    func GET(_ url: String, params: [String: AnyObject]?, result: @escaping DetailtResponse) -> Void {
        
        Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (reponse) in
            switch reponse.result {
            case .success(let userData):
                result(userData as AnyObject, nil)
                break
            case .failure(let error):
                result(nil, error as NSError)
                break
            }
        }
        
        
//        Alamofire.request(.GET, url, parameters: params).responseJSON { (response: Response<AnyObject, NSError>) in
//            switch response.result {
//            case .Success(let userData):
//                result(userData, nil)
//                break
//            case .Failure(let error):
//                result(nil, error)
//                break
//            }
//        }
    }
    
    func requestURL(_ uri: String) -> String {
        
        return BE24RequestManager.baseURL + uri
    }

    func login(_ username: String, password: String, result: @escaping DetailtResponse) -> Void {
        
        let url = requestURL(URI_Login)
        let params = [
            "username": username,
            "password": password
        ]
        POST(url, params: params as [String : AnyObject], result: result)
        
    }
    
    func getData(_ userid: Int, token: String, result: @escaping (([BE24LocationModel]?, JSON?, NSError?) -> Void)) -> Void {
        let url = requestURL(UIR_State + String(userid) + "/" + token)
        print(url)
        GET(url, params: nil) { (response: AnyObject?, error: NSError?) in
            if response != nil {
                let json = JSON(response!)
                print(json)
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
