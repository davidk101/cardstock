//
//  MenuViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/9/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var helperModeLbl: UILabel!
    @IBOutlet weak var helperModeSwitch: UISwitch!
    @IBOutlet weak var loginOutBtn: UIButton!
    
    // called after view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // called before the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // default
        helperModeSwitch.isOn = false
        helperModeSwitch.isHidden = true // we dont know if user is driver yet
        helperModeLbl.isHidden = true // we dont know if user is driver yet
        
    }
    
    // setting up observer to watch database for changes
    func observeHirersAndHelpers(){
        
        // snapshot refers to the 'users' dictionary here
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            // parsing through every child of the 'users' dictionary
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                // checking if key of each child is equal to our uid
                for snap in snapshot{
                    
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLbl.text = "HIRER"
                        
                    }
                }
            }
            
        })
        
        DataService.instance.REF_HELPERS.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot{
                    
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLbl.text = "HELPER"
                    }
                }
            }
        }
        
    })
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        present(loginVC!, animated: true, completion: nil)
        
        // if you optionally cast "as?" you must force unwrap it "loginVC!"
    }
    

}
