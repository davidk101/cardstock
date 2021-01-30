//
//  UIViewExt.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/29/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval){
        
        UIView.animate(withDuration: duration){
            self.alpha = alphaValue
        }
    }
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification){ // this func called -> animates the View to go above the keyboard
        
        // duration for animation of moving view up is the same as that of keyboard moving up
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let curFrame = (notification.userInfo![)
    }
}
