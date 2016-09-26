//
//  BE24LoginVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 LankaWebHouse. All rights reserved.
//

import UIKit

class BE24LoginVC: BE24ViewController, UITextFieldDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    @IBAction func onPressSign(sender: AnyObject) {
//        if vaildUserInfo() {
        
//        }
        self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
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
