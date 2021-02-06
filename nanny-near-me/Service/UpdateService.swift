//
//  UpdateService.swift
//  nanny-near-me
//
//  Created by David Kumar on 2/6/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

// singleton
class UpdateService{
    
    static var instance = UpdateService()
    
    // changes the hirer/user location based on mapView location update i.e. mapView passes coordinate changes in real time to Firebase
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D){
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // parsing through all the children of "users"
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for user in userSnapshot{
                    // we know for sure this is the current user
                    if user.key == Auth.auth().currentUser?.uid{
                        
                        // adds the new key-value pair "coordinates" in addition to "provider" already added in the past
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                    }
                }
            }
        })
    }
    
    // i.e. mapView passes coordinate changes in real time to Firebase
    func updateHelperLocation(withCoordindate coordinate: CLLocationCoordinate2D){
        
        DataService.instance.REF_HELPERS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // parsing through all the children of "helpers"
            if let helperSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for helper in helperSnapshot{
                    // ensuring helper's key matches helper's current user ID
                    if helper.key == Auth.auth().currentUser?.uid{
                        
                        // ensuring pickup mode is on for the helper
                        if helper.childSnapshot(forPath: "isHelperModeEnabled").value as? Bool == true{
                            
                            DataService.instance.REF_HELPERS.child(helper.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                        }
                        
                    }
                }
            }
        })
    }
    
}
