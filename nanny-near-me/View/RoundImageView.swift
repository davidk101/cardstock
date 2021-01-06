//
//  RoundImageView.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    

    func setupView(){
        
        self.layer.cornerRadius = self.frame.width / 2 // making imageView to be circular
        self.clipsToBounds = true // ensured image fits into circle
        
    }

}
