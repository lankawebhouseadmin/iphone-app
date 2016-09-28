//
//  BE24LoginVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import DKChainableAnimationKit

class BE24LoginVC: BE24ViewController, UITextFieldDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    override func setupLayout() {
        super.setupLayout()
        
        
    }
    
    @IBAction func onPressSign(sender: AnyObject) {
        if vaildUserInfo() {
            SVProgressHUD.show()
            requestManager().login(self.txtUsername.text!, password: self.txtPassword.text!, result: { (result: AnyObject?, error: NSError?) in
                if result != nil {
                    let json = JSON(result!)
                    let message = json["message"].stringValue
                    let success = json["success"].stringValue
                    if success == "true" {
                        let appManager = self.appManager()
                        appManager.currentUser = BE24UserModel(data: json["data"])
                        appManager.token = json["token"].stringValue
                        self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
                    } else {
                        self.showSimpleAlert("Error", Message: message, CloseButton: "Close", Completion: nil)
                    }
                } else {
                    self.showSimpleAlert("Error", Message: error?.localizedDescription, CloseButton: "Close", Completion: nil)
                }
                SVProgressHUD.dismiss()
            })
        }
//        self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
    }
    
    private func vaildUserInfo() -> Bool {
        if self.txtUsername.text?.characters.count == 0 {
            self.showSimpleAlert("Warning", Message: "Username shouldn't be empty.", CloseButton: "Close", Completion: {
                
            })
            return false
        } else if self.txtPassword.text?.characters.count < 6 {
            self.showSimpleAlert("Warning", Message: "Password shouldn't be less than 6 characters.", CloseButton: "Close", Completion: {
                
            })
            return false
        }
        return true
    }
    
    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtUsername {
            self.btnForgotPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            self.txtPassword.resignFirstResponder()
            
        }
        return true
    }
}
