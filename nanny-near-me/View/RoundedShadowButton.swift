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
    
    override func awakeFromNib() {
        setupView()
    }

    func animateButton(shouldLoad: Bool, withMessage message: String?){
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.color = UIColor.darkGray
        spinner.alpha = 0.0
        spinner.hidesWhenStopped = true
        
        spinner.tag = 21
         
        
        if shouldLoad{
            
            self.addSubview(spinner)
            
            self.setTitle("", for: .normal) // removing title
            UIView.animate(withDuration: 0.2, animations: { // animating button to become a circle
                
                self.layer.cornerRadius = self.frame.height / 2 // making square into circle
                
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height) // X coordinates ensure circle is in the center of screen - width and height makes into square
                
            }, completion: {(finished) in
                
                if finished == true{
                    
                    spinner.startAnimating()
                    
                    spinner.center = CGPoint(x:self.frame.width/2 + 1, y:self.frame.width/2 + 1)
                    UIView.animate(withDuration: 0.2) {
                        spinner.alpha = 1.0
                    }
                    
                }
            })
            
            self.isUserInteractionEnabled = false // ensures button is unclickable
            
        }
        else{
            self.isUserInteractionEnabled = true
            
            for subview in self.subviews{ // iterating through all subviews
                
                if subview.tag == 21{ // ensuring only the spinner subview is removed
                    subview.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layer.cornerRadius = 5.0
                self.frame = self.originalSize! // force unwrapping here since it is an optional - SELF.originalSize needed to refer to correct var outside closure
                self.setTitle(message, for: .normal)
                
            }
            
        }
    }
}
