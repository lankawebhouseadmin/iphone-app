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
//    var imgLogo: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    /// Constraint
    @IBOutlet weak var constraintHeightOfLogo: NSLayoutConstraint!
    @IBOutlet weak var constraintTopOfLogo: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomSpaceForKeyboard: NSLayoutConstraint!
    
    private var didSetFrameOfLogo = false
    
    // MARK: - Life cycle
    override func setupLayout() {
        super.setupLayout()
        
        let screenSize = UIScreen.mainScreen().bounds.size
        self.constraintTopOfLogo.constant = -(screenSize.height * 0.5 * 0.3)
        self.constraintHeightOfLogo.constant = 1
        
        self.imgLogo.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        self.viewLogin.alpha = 0
        
        let usernamePassword = appManager().getUsernamePassword()
        txtUsername.text = usernamePassword.0
        txtPassword.text = usernamePassword.1
        
//        self.login("rachel_stern", password: "rachel1234")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLogo()
    }
    
    private func animateLogo() {
        
        self.constraintTopOfLogo.constant = 0
        self.constraintHeightOfLogo.constant = 180

        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
            self.imgLogo.transform = CGAffineTransformMakeScale(1, 1)

        }) { (success: Bool) in
            UIView.animateWithDuration(0.5, animations: {
                self.viewLogin.alpha = 1
//                self.autoLogin()
            })

        }
    }
    
    // MARK: - Override 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    override func keyboardWillShowRect(keyboardSize: CGSize) {
        let bottomTextField = self.viewLogin.frame.origin.y + CGRectGetMaxY(self.txtPassword.frame) + 5
        if bottomTextField > self.view.bounds.size.height - keyboardSize.height {
            let dy = bottomTextField - (self.view.bounds.size.height - keyboardSize.height)
            self.constraintBottomSpaceForKeyboard.constant = 40 + dy
            self.updateConstraintWithAnimate(true)
        }
    }
    
    override func keyboardWillHideRect() {
        self.constraintBottomSpaceForKeyboard.constant = 40
        self.updateConstraintWithAnimate(true)
    }
    
    // MARK: - Login
    @IBAction func onPressSign(sender: AnyObject) {
        if vaildUserInfo() {
            login(self.txtUsername.text!, password: self.txtPassword.text!)
        }
//        self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
    }
    
    private func autoLogin() {
        if self.txtUsername.text?.characters.count > 0 && self.txtPassword.text?.characters.count >= 6 {
            login(self.txtUsername.text!, password: self.txtPassword.text!)
        }
    }
    
    private func login(username: String, password: String) {
        SVProgressHUD.show()
        requestManager().login(username, password: password, result: { (result: AnyObject?, error: NSError?) in
            
//            self.txtPassword.text = nil
//            self.txtUsername.text = nil
            
            self.appManager().saveUsername(username, password: password)
            
            if result != nil {
                let json = JSON(result!)
                let message = json["message"].stringValue
                let success = json["success"].stringValue
                if success == "true" {
                    let appManager = self.appManager()
                    appManager.currentUser = BE24UserModel(data: json["data"])
                    appManager.token = json["token"].stringValue
                    
                    print ("userID : " + String(appManager.currentUser!.id) + "  <:::>  " + "token : " + appManager.token!)
                    
                    self.requestManager().getData(appManager.currentUser!.id, token: appManager.token!, result: { (result: [BE24LocationModel]?, json: JSON?, error: NSError?) in
                        if result != nil {
                            appManager.stateData = result!
                            
                            self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
                            
                        } else {
                            self.showSimpleAlert("Error", Message: error!.localizedDescription, CloseButton: "Close", Completion: {
                                
                            })
                        }
                        SVProgressHUD.dismiss()
                    })
                    return
                } else {
                    self.showSimpleAlert("Error", Message: message, CloseButton: "Close", Completion: nil)
                }
            } else {
                self.showSimpleAlert("Error", Message: error?.localizedDescription, CloseButton: "Close", Completion: nil)
            }
            SVProgressHUD.dismiss()
        })

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
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtUsername {
            self.txtPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            self.txtPassword.resignFirstResponder()
            self.onPressSign(self.btnSignin)
        }
        return true
    }
}
