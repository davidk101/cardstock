//
//  PassengerAnnotation.swift
//  nanny-near-me
//
//  Created by David Kumar on 2/28/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation{

    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String){
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    
}
