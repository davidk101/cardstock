//
//  HomeViewController.swift
//  nanny-near-me
//
//  Created by David Kumar on 1/5/21.
//  Copyright © 2021 David Kumar. All rights reserved.
//  

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController , MKMapViewDelegate{
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    var delegate: CenterVCDelegate?
    
    var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        
        mapView.delegate = self // setting mapview's delegate to be ViewController
    }
    
    func checkLocationAuthStatus(){
        
        // checks if authorized by user to start retrieving lcoation
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            manager?.delegate = self
            
            // the most accurate location monitoring
            manager?.desiredAccuracy = kCLLocationAccuracyBest
            
            manager?.startUpdatingLocation()
        }
        else{
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation(){
        
        
    }
    
    @IBAction func actionBtnWasPressed(_ sender: Any) {
        
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
    }
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        
        delegate?.toggleLeftPanel()
    }
    
}

// conforming to the delegate
extension HomeViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
