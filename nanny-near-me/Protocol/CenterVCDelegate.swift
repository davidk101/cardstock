//
//  CenterVCDelegate.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/27/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

// Delegation allows objects to be able to change their appearance / state based on dynamic changes
// Delegation is often achieved by using protocols, since it allows the delegate object to be of any class
// Delegation is also very useful when you want to pass information between objects. You can very easily create your own protocols and sign up your own objects to follow them

protocol CenterVCDelegate{
    
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
