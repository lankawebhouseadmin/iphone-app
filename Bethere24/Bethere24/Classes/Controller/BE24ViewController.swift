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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    private func addKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    private func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        var keyboardBound : CGRect = CGRectZero
        notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardBound)
        keyboardWillShowRect(keyboardBound.size)
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        keyboardWillHideRect()
    }
    
    func keyboardWillShowRect(keyboardSize : CGSize) -> Void {
        
    }
    
    func keyboardWillHideRect() -> Void {
        
    }

}
