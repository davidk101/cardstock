//
//  RoundedShadow.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class RoundedShadow: UIView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView(){
        
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width:0, height: 5.0)
        self.layer.cornerRadius = 5.0
    }

}
