//
//  LoginViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/29/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard() // View is moved up as soon as keyboard is displayed when UITextField is tapped
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true) // dismisses keyboard
        
    }
    
}
