//
//  HomeViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//  

import UIKit
import MapKit

class HomeViewController: UIViewController , MKMapViewDelegate{
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self // setting mapview's delegate to be ViewController
    }
    
    @IBAction func actionBtnWasPressed(_ sender: Any) {
        
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    
}
