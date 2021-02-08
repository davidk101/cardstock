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
    @IBOutlet weak var destinationTextField: UITextField!
    
    var delegate: CenterVCDelegate?
    
    var manager: CLLocationManager?
    
    var regionRadius: CLLocationDistance = 1000 // metre radius from current location
    
    var tableView = UITableView()
    
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

extension HomeViewController: UITextFieldDelegate{
    
    // when textfield is selected
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == destinationTextField){
            
            // start position: bottom most position of screen
            // end position: view.frame.height - 170
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0
            tableView.rowHeight = 60
            
            // registering a cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tag = 18
            
            view.addSubview(tableView)
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}
