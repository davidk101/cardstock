//
//  LoginViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/29/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard() // View is moved up as soon as keyboard is displayed when UITextField is tapped
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true) // dismisses keyboard
        
    }
    
    @IBAction func authBtnWasPressed(_ sender: Any) {
        
        if emailField.text != nil && passwordField.text != nil{
            
            //authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true) // hiding keyboard
            
            if let email = emailField.text, let password = passwordField.text{ // closure: email and password fields have text
                
                // ensuring loginVC as the page for BOTH sign up and login functionality
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    // logging in a currently existing user
                    // only executed if 'user' exists
                    if error == nil{
                        
                        if let user = user{
                            
                            if self.segmentedControl.selectedSegmentIndex == 0{ // i.e. hirer is selected
                                
                                let userData = ["provider": user.user.providerID] as [String: Any]
                                
                                DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isHelper: false)
                            }
                            else{ // i.e. helper is selected
                                
                                let userData = ["provider":user.user.providerID, "userIsHelper": true, "isHelperModeEnabled": false, "helperIsOnTrip":false] as [String: Any]
                                
                                DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isHelper: true)
                                
                            }
                        }
                        
                        self.dismiss(animated: true, completion: nil) // removing LoginVC
                    }
                    
                    // user does not currently exist
                    else{
                        
                        print(error.debugDescription + " dab")
                        
                        // creating new user
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            
                            if error != nil{
                                 
                                print(error.debugDescription + " hello world")
                                
                                if let errorCode = AuthErrorCode(rawValue: error!._code){
                                    
                                    switch errorCode {
                                        
                                    case .invalidEmail:
                                        print()
                                    case .emailAlreadyInUse:
                                        print()

                                    default:
                                        print()
                                    }
                                }
                            }
                            
                            // no errors in creating new user
                            else{
                                
                                if let user = user{
                                    if self.segmentedControl.selectedSegmentIndex == 0{
                                        let userData = ["provider": user.user.providerID, "email":email,"password":password] as [String: Any]
                                        
                                        DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isHelper: false)
                                    }
                                        
                                    else{
                                        let userData = ["provider": user.user.providerID as Any, "userIsHelper": true,"isHelperModeEnabled": false, "helperIsOnTrip": false,"email":email,"password":password] as [String: Any]
                                        
                                        DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isHelper: true)
                                    }
                                }
                            }
                            
                            self.dismiss(animated: true, completion: nil) // dismissing loginVC
                        }
                    }
                }
            }
        }
    }
}
