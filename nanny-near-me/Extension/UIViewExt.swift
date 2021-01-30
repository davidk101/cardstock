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
    
    // this func called -> animates the View to go above the keyboard
    @objc func keyboardWillChange(_ notification: NSNotification){
        
        // duration for animation of moving view up is the same as that of duration of keyboard moving up
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        // frame of the keyboard
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        // frame of the enitre view
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        // using the above values to animate
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
