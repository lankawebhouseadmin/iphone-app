//
//  UIViewController+BE24.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit
//import MZFormSheetPresentationController


extension UIViewController {


    func setupLayout() -> Void {
        
    }
    
    
    func updateConstraintWithAnimate(_ animate: Bool) -> Void {
        if animate == true {
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (complete) in
                    
            })
        } else {
            updateViewConstraints()
        }
    }
    
    func appManager() -> BE24AppManager {
        return BE24AppManager.sharedManager
    }
    
    func requestManager() -> BE24RequestManager {
        return BE24RequestManager.sharedManager
    }

    func enableButton(_ button: UIButton) -> Void {
        button.isEnabled = true
        button.alpha = 1
    }
    
    func disableButton(_ button: UIButton) -> Void {
        button.isEnabled = false
        button.alpha = 0.5
    }
    
    // MARK: - NSNotification Selector
    
    internal func addNotificationSelectors() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationPostedMedia(_:)), name: APPNOTIFICATION.POSTEDMEDIA, object: nil)
        
    }
    
    internal func removeNotificationSelectors() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: APPNOTIFICATION.POSTEDMEDIA, object: nil)
    }

    func showSimpleAlert(_ title: String?, Message message: String?, CloseButton closeButton: String?, Completion completion:(() -> Void)?) -> Void {
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction.init(title: closeButton, style: .cancel) { (alertAction: UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }
        alertView.addAction(closeAction)
        present(alertView, animated: true) {
        }
    }
    
    func validateEmail(_ enteredEmail:String?) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancleNavigationController(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}


