//
//  DataService.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/30/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

// singleton: accessed globally throughout the app
class DataService{
    
    // instantiated for the entire lifecycle of the app
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users") // creating a folder OR appending data to the folder name in the String
    private var _REF_HELPERS = DB_BASE.child("helpers")
    private var _REF_TRIPS = DB_BASE.child("trips")
    
    // data encapsulation: accessing private vars w/o modifying them directly
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_HELPERS: DatabaseReference{
        return _REF_HELPERS
    }
    
    var REF_TRIPS: DatabaseReference{
        return _REF_TRIPS
    }
    
    // creating a user/helper
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,Any>, isHelper: Bool){
        
        // https://...firebasio.com/helpers/bib32ihbii/userData will be the path
        if isHelper{
            REF_HELPERS.child(uid).updateChildValues(userData)
        }
        else{
            // https://...firebasio.com/users/vhbwe11hbhib1/userData will be the path
            REF_USERS.child(uid).updateChildValues(userData)
        }
        
    }
}
