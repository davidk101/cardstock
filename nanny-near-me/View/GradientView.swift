//
//  GradientView.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class GradientView: UIView  {

    let gradient = CAGradientLayer()
    
    // after interface builder is setup, this function is overriden
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView(){
        
        gradient.frame = self.bounds // takes up its own UIView frame
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero // top-left point of simulator 
        gradient.endPoint = CGPoint(x:0 ,y:1) // covers the entire view vertically
        gradient.locations = [0.8, 1.0] // first color takes 0-80% of UIView and second color takes 80-100% of view
        //self.layer.addSublayer(gradient)
        layer.insertSublayer(gradient, at: 0)// source stackoverflow.com/questions/20243424/add-calayer-below-uiview
    }
}
