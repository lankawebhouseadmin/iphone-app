//
//  BE24LoginVC.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/25/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import DKChainableAnimationKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class BE24LoginVC: BE24ViewController, UITextFieldDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
//    var imgLogo: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    var subTitle = ""
    
    /// Constraint
    @IBOutlet weak var constraintHeightOfLogo: NSLayoutConstraint!
    @IBOutlet weak var constraintTopOfLogo: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomSpaceForKeyboard: NSLayoutConstraint!
    
    fileprivate var didSetFrameOfLogo = false
    
    // MARK: - Life cycle
    
    override func setupLayout() {
        super.setupLayout()
        
        let screenSize = UIScreen.main.bounds.size
        self.constraintTopOfLogo.constant = -(screenSize.height * 0.5 * 0.3)
        self.constraintHeightOfLogo.constant = 1
        
        self.imgLogo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.viewLogin.alpha = 0
        
        let usernamePassword = appManager().getUsernamePassword()
        txtUsername.text = usernamePassword.0
        txtPassword.text = usernamePassword.1
        
//        self.login("rachel_stern", password: "rachel1234")
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(onPressLogo(_:)))
        longGesture.minimumPressDuration = 3
        self.imgLogo.addGestureRecognizer(longGesture)
        self.imgLogo.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLogo()
    }
    
    fileprivate func animateLogo() {
        
        self.constraintTopOfLogo.constant = 0
        self.constraintHeightOfLogo.constant = 180

        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
            self.imgLogo.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: { (success: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.viewLogin.alpha = 1
//                self.autoLogin()
            })

        }) 
    }
    
    // MARK: - Override 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func keyboardWillShowRect(_ keyboardSize: CGSize) {
        let bottomTextField = self.viewLogin.frame.origin.y + self.txtPassword.frame.maxY + 5
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
    @IBAction func onPressSign(_ sender: AnyObject) {
        if vaildUserInfo() {
            login(self.txtUsername.text!, password: self.txtPassword.text!)
        }
//        self.performSegueWithIdentifier(APPSEGUE_gotoMainVC, sender: self)
    }
    
    fileprivate func autoLogin() {
        if self.txtUsername.text?.characters.count > 0 && self.txtPassword.text?.characters.count >= 6 {
            login(self.txtUsername.text!, password: self.txtPassword.text!)
        }
    }
    
    fileprivate func login(_ username: String, password: String) {
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
                    (UIApplication.shared.delegate as! AppDelegate).setTimeZone(appManager.currentUser!.personTimeZone!)
                    
                    print ("userID : " + String(appManager.currentUser!.id) + "  <:::>  " + "token : " + appManager.token!)
                    
                    self.requestManager().getData(appManager.currentUser!.id, token: appManager.token!, result: { (result: [BE24LocationModel]?, json: JSON?, error: NSError?) in
                        if result != nil {
                            appManager.stateData = result!
                            print(result)
                            
                            self.performSegue(withIdentifier: APPSEGUE_gotoMainVC, sender: self)
                            
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
    
    fileprivate func vaildUserInfo() -> Bool {
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
    
    func onPressLogo(_ sender: AnyObject) -> Void {
        let alertController = UIAlertController(title: "Select server", message: nil, preferredStyle: .alert)
        let stageAction = UIAlertAction(title: "Stage", style: .default) { (action: UIAlertAction) in
            BE24RequestManager.baseURL = "http://staging.bt24now.com"
            self.subTitle = "Dev"
            
        }
        
        let uatAction = UIAlertAction(title: "UAT", style: .default) { (action: UIAlertAction) in
            BE24RequestManager.baseURL = "http://uat.bt24go.com"
            self.subTitle = "Utc"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(stageAction)
        alertController.addAction(uatAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtUsername {
            self.txtPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            self.txtPassword.resignFirstResponder()
            self.onPressSign(self.btnSignin)
        }
        return true
    }
}
