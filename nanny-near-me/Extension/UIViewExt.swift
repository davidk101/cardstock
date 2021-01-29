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
}
