//
//  CircleView.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class CircleView: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet{
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        
        self.layer.borderColor = borderColor?.cgColor
    }

}
