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

class HomeViewController: UIViewController {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    
    var delegate: CenterVCDelegate?
    
    var manager: CLLocationManager?
    
    var regionRadius: CLLocationDistance = 1000 // metre radius from current location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        
        manager?.delegate = self
        // the most accurate location monitoring
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationAuthStatus()
        
        mapView.delegate = self // setting mapview's delegate to be ViewController
        
        // only after setting mapView delegate
        centerMapOnUserLocation()
    }
    
    func checkLocationAuthStatus(){
        
        // checks if authorized by user to start retrieving lcoation
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            manager?.startUpdatingLocation()
        }
        else{
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnUserLocation(){
        
        // setting rectangular region with center
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: regionRadius*2.0, longitudinalMeters: regionRadius*2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        
        centerMapOnUserLocation()
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
    
    // monitors change in auth status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthStatus()
        
        if status == .authorizedAlways{
            
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}

// conforming to the delegate
extension HomeViewController: MKMapViewDelegate{
    
    // updates when location of current user changes in mapView
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateHelperLocation(withCoordindate: userLocation.coordinate)
    }
}
