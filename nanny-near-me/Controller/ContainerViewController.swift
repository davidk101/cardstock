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
    //case HomeViewController
    case homeVC
}

var showVC: ShowWhichVC = .homeVC // default VC shown when app launches is HomeViewController

class ContainerViewController: UIViewController {
    
    var homeVC: HomeViewController!
    var menuVC: MenuViewController!
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed{ // menu collapsed initially
        didSet{
            let shouldShowShadow = (currentState != .collapsed)
            
            shouldShowShadowForCenterViewController(status: shouldShowShadow)
        }
    }
    
    var isHidden = false // the status of the HomeVC
    let centerPanelExpandedOffset: CGFloat = 160 // determines how far the panel should expand
    
    var tap: UITapGestureRecognizer! // setting up to recognize tap on the white cover to close panel/menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCenter(screen: showVC)
        
    }
    
    func initCenter(screen: ShowWhichVC){ // inits VC at the center of screen
        
        var presentingController: UIViewController // holds VC in place as center VC
        
        showVC  = screen
        
        if homeVC == nil{ // if not yet instantiated
            homeVC = UIStoryboard.homeViewController()
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
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isHidden
    }
}

// conforming to protocol | functionality for delegate is stored in this extension
extension ContainerViewController: CenterVCDelegate{ // ContainerVC inherits from CenterVCDelegate
    
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
            menuVC = UIStoryboard.menuViewController()
            addChildSidePanelViewController(menuVC!)
        }
        
    }
    
    func addChildSidePanelViewController(_ sidePanelController: MenuViewController){
        view.insertSubview(sidePanelController.view, at: 0) // error-prone line
        addChild(sidePanelController)

        sidePanelController.didMove(toParent: self)
    }
    
    @objc func animateLeftPanel(shouldExpand: Bool) { // add shadow to the other VC and slide current VC to the right
        
        if shouldExpand{
            isHidden = !isHidden // inverts value when expanded
            
            animateStatusBar()
            setupWhiteCoverView()
            
            currentState = .expanded
            
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset) // captures width of screen and slides the X point on the left of the screen 160 pixels to the right
        }
        else{
            
            isHidden = !isHidden
            animateStatusBar()
            hideWhiteCoverView()
            
            animateCenterPanelXPosition(targetPosition: 0) { (finished) in
                if finished == true{
                    self.currentState = .collapsed
                    self.menuVC = nil // removing instance of VC from memory
                }
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func setupWhiteCoverView(){ // create UIView, add as subview
        
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)) // covers entire view
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = 25 // arbitrary tag to identify
        self.centerController.view.addSubview(whiteCoverView)
        
        whiteCoverView.fadeTo(alphaValue: 0.75, withDuration: 0.2)
        
        //UIView.animate(withDuration: 0.2) {
        //    whiteCoverView.alpha = 0.75
        //}
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)) ) // self: current VC
        
        self.centerController.view.addGestureRecognizer(tap)
        
    }
    
    func hideWhiteCoverView(){
        
        centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews{
            if subview.tag == 25{
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0.0 // fade out happens first
                }, completion: { (finished) in
                    subview.removeFromSuperview() // removed from supoer view after fading out
                })
            }
        }
    }
    
    // adding a vertical shadow for the current center controller to distinguish from other VC
    func shouldShowShadowForCenterViewController(status: Bool){
        
        if status{
            centerController.view.layer.shadowOpacity = 0.6
        }
        else{
            centerController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func animateStatusBar(){ // status bar is the HomeVC essentially
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate() // in-built function
        })
    }
    
}

// private: only accessible by ContainerVC
private extension UIStoryboard{ // access all VC from the storyboard and instantiate those VC dynamically
    
    class func mainStoryboard() -> UIStoryboard{ // modifies storyboard dynamically
        return UIStoryboard(name: "Main", bundle: Bundle.main) // accesses Main.storyboard
    }
    
    class func menuViewController() -> MenuViewController?{ // returns an instance of MenuVC
        return mainStoryboard().instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController // optionally casting as MenuVC
    }
    
    class func homeViewController() -> HomeViewController?{ // returns instance of HomeVC
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
}

 

