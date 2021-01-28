//
//  CenterVCDelegate.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/27/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

protocol CenterVCDelegate{
    
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
