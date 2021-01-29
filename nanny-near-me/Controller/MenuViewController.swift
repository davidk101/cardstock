//
//  MenuViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/9/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        present(loginVC!, animated: true, completion: nil)
        
        // if you optionally cast "as?" you must force unwrap it "loginVC!"
    }
    

}
