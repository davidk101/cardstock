//
//  ContainerViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/9/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit
import QuartzCore // animates VC sliding

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

private extension UIStoryboard{ // access all VC from the storyboard and instantiate them dynamically
    
    class func mainStoryboard() -> UIStoryboard{ // modifies storyboard dynamically
        return UIStoryboard(name: "Main", bundle: Bundle.main) // accesses storyboard
    }
    
    class func MenuViewController() -> MenuViewController?{ // returns an instance of MenuVC
        return mainStoryboard().instantiateInitialViewController() as? MenuViewController // optionally casting as MenuVC
    }
    
    class func HomeViewController() -> HomeViewController?{
        return mainStoryboard().instantiateInitialViewController() as? HomeViewController
    }
}
