//
//  ContainerViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/9/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

// stores other VC in ContainerVC and displays the appropriate VC

import UIKit
import QuartzCore // animates VC sliding

enum SlideOutState{ // checks if menu is expanded or collapsed
    case collapsed
    case expanded
}

enum ShowWhichVC{
    case HomeViewController
}

var showVC: ShowWhichVC = .HomeViewController // default VC shown when app launches is HomeViewController

class ContainerViewController: UIViewController {
    
    var homeVC: HomeViewController!
    var menuVC: MenuViewController!
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed // menu collapsed initially
    
    var isHidden = false // the status of the HomeVC
    let centerPanelExpandedOffset: CGFloat = 160 // determines how far the panel should expand
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initCenter(screen: ShowWhichVC){ // inits VC at the center of screen
        
        var presentingController: UIViewController // holds VC in place as center VC
        
        showVC  = screen
        
        if homeVC == nil{ // if not yet instantiated
            homeVC = UIStoryboard.HomeViewController()
            homeVC.delegate = self // instantiate delegate to be containerVC
        }
        
        presentingController = homeVC
        
        // clearing existing copies for purpose of memory
        if let con = centerController{
            con.view.removeFromSuperview()
            con.removeFromParent()
        }
        
        centerController = presentingController
        
        view.addSubview(centerController.view) // add the view
        addChild(centerController) // add the controller
        centerController.didMove(toParent: self) // moved to parent controller
        
    }
}

// conforming to protocol
extension ContainerViewController: CenterVCDelegate{ // ContainerVC inherits from ContainerVCDelegate
    
    func toggleLeftPanel() { // expands or closes as needed
        
        let notAlreadyExpanded = (currentState != .expanded)
        
        if notAlreadyExpanded{ // if not yet expanded
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        
        // instantiate menuVC
        if menuVC == nil{
            menuVC = UIStoryboard.MenuViewController()
            addChildSidePanelViewController(menuVC!)
        }
        
        
    }
    
    func addChildSidePanelViewController(_ sidePanelController: MenuViewController){
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParent: self)
        
        
        
    }
    
    func animateLeftPanel(shouldExpand: Bool) { // add shadow to the other VC and slide current VC to the right
        
        
    }
    
}

private extension UIStoryboard{ // access all VC from the storyboard and instantiate those VC dynamically
    
    class func mainStoryboard() -> UIStoryboard{ // modifies storyboard dynamically
        return UIStoryboard(name: "Main", bundle: Bundle.main) // accesses Main.storyboard
    }
    
    class func MenuViewController() -> MenuViewController?{ // returns an instance of MenuVC
        return mainStoryboard().instantiateInitialViewController() as? MenuViewController // optionally casting as MenuVC
    }
    
    class func HomeViewController() -> HomeViewController?{ // returns instance of HomeVC
        return mainStoryboard().instantiateInitialViewController() as? HomeViewController
    }
}

 

