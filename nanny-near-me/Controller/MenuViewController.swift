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
        
        observeHirersAndHelpers()
        
        // checking if there is anyone logged in
        if Auth.auth().currentUser == nil{
            
            userEmailLbl.text = ""
            userAccountTypeLbl.text = ""
            loginOutBtn.setTitle("Sign Up / Login", for: .normal)
            
        }
            // there is someone logged in
        else{
            
            userEmailLbl.text = Auth.auth().currentUser?.email
            userAccountTypeLbl.text = ""
            loginOutBtn.setTitle("Logout", for: .normal)
        }
    }
    
    // setting up observer to watch database for changes
    func observeHirersAndHelpers(){
        
        // snapshot refers to the 'users' dictionary here
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            // // each snap is a hirer | parsing through every child of the 'users' dictionary
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                // checking if key of each child is equal to our uid
                for snap in snapshot{
                    
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLbl.text = "HIRER"
                        
                    }
                }
            }
            
        })
        
        // snapshot refers to the 'helpers' dictionary here
        DataService.instance.REF_HELPERS.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            // parsing through every child of the 'helpers' dictionary
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                // each snap is a helper
                for snap in snapshot{
                    
                    // checking if key of each child is equal to our uid
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLbl.text = "HELPER"
                        self.helperModeSwitch.isHidden = false
                        
                        // checking if helper was looking to do pickups
                        let switchStatus = snap.childSnapshot(forPath: "isHelperModeEnabled").value as! Bool
                        self.helperModeSwitch.isOn = switchStatus
                        
                        self.helperModeLbl.isHidden = false
                    }
                }
            }
        })
    }
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        
        // logging user in
        if Auth.auth().currentUser == nil{
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            
            present(loginVC!, animated: true, completion: nil)
            
            // if you optionally cast "as?" you must force unwrap it "loginVC!"
        }
            
        // logging user out
        else{
            
            do{
                try Auth.auth().signOut()
                
                // repeating these steps again as in viewDidAppear() as we are trying to make changes as soon as the button it hit
                // and not only when the view appears 
                userEmailLbl.text = ""
                userAccountTypeLbl.text = ""
                helperModeLbl.text = ""
                helperModeSwitch.isHidden = true
                loginOutBtn.setTitle("Sign Up / Login", for: .normal)
            }
            catch (let error){
                
                print(error)
            }
            
        }

    }
    

}
