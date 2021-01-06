//
//  RoundedShadowButton.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {
    
    var originalSize : CGRect?
    
    func setupView(){
        
        originalSize = self.frame
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero // shadow wont move
    }

    func animateButton(shouldLoad: Bool, withMessage message: String?){
        
        if shouldLoad{
            
            self.setTitle("", for: .normal) // removing title
            UIView.animate(withDuration: 0.2, animations: { // animating button to become a circle
                
                self.layer.cornerRadius = self.frame.height / 2 // making square into circle
                
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height) // X coordinates ensure circle is in the center of screen - width and height makes into square 
                
            }, completion: {(finished) in
                
                if finished == true{
                    
                }
            })
        }
    }
}
