//
//  BE24ViewController.swift
//  Bethere24
//
//  Created by Prbath Neranja on 9/24/16.
//  Copyright © 2016 BeThere24. All rights reserved.
//

import UIKit

class BE24ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    fileprivate func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    fileprivate func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) -> Void {
        var keyboardBound : CGRect = CGRect.zero
        (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).getValue(&keyboardBound)
        keyboardWillShowRect(keyboardBound.size)
    }
    
    func keyboardWillHide(_ notification: Notification) -> Void {
        keyboardWillHideRect()
    }
    
    func keyboardWillShowRect(_ keyboardSize : CGSize) -> Void {
        
    }
    
    func keyboardWillHideRect() -> Void {
        
    }

}
