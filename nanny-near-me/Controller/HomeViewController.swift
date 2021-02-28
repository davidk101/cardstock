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
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var centerMapButton: UIButton!
    
    var delegate: CenterVCDelegate?
    
    var manager: CLLocationManager?
    
    var currentUserId = Auth.auth()?.currentUser?.uid
    
    var regionRadius: CLLocationDistance = 1000 // metre radius from current location
    
    // instantiating tableView
    var tableView = UITableView()
    
    var matchingItems: [MKMapItem] = [MKMapItem]() // instantiating for local search
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        
        manager?.delegate = self
        // the most accurate location monitoring
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationAuthStatus()
        
        mapView.delegate = self // setting mapview's delegate to be ViewController
        destinationTextField.delegate  = self // telling this text field to receive commands from this VC
        
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
        centerMapButton.fadeTo(alphaValue: 0.0, withDuration: 0.2) // removes button when centred
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
        // error must be fixed
        //UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
        //UpdateService.instance.updateHelperLocation(withCoordindate: userLocation.coordinate)
    }
    
    // visual representation of annotation object
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? DriverAnnotation{
            
            let identifer = "driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifer)
            view.image = UIImage(named: "driverAnnotation")
            return view
        }
        
        else if let annotation = annotation as? PassengerAnnotation{
            
            let identifier = "passenger"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "currentLocationAnnotation")
            return view
        }
        
        return nil
        
    }
    
    func performSearch(){
        
        matchingItems.removeAll() // removing previous search results from array
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationTextField.text
        request.region = mapView.region // searches for locations in the mapView first
        
        let search = MKLocalSearch(request: request) // mapView API
        
        search.start { (response, error) in
            if error != nil{
                print(error.debugDescription)
            }
            else if response?.mapItems.count == 0{
                print("no locations found")
            }
            else{
                for mapItem in response!.mapItems{
                    self.matchingItems.append(mapItem as MKMapItem)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // adding center map button as soon as uncentred
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
        
    }
}

extension HomeViewController: UITextFieldDelegate{
    
    // when textfield is selected
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == destinationTextField){
            
            // start position: bottom most position of screen
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0
            
            // registering a cell
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            
            tableView.delegate = self
            tableView.dataSource = self
            
            // sort of as an identifying key
            tableView.tag = 18
            tableView.rowHeight = 70
            
            view.addSubview(tableView)
            animateTableView(shouldShow: true)
        }
    
    }
    
    // after pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == destinationTextField{
            performSearch()
            // hides keyboard and removes cursor for typing
            view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // after pressing clear button 
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        // removing entries from local search
        matchingItems = []
        tableView.reloadData()
        
        centerMapOnUserLocation()
        return true
    }
    
    func animateTableView(shouldShow: Bool){
        
        if (shouldShow){
            
            UIView.animate(withDuration: 0.2, animations: {
                
                // end position: 170 units above bottom-most point
                self.tableView.frame = CGRect(x: 20, y: 230, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            })
        }
        else{
            
            UIView.animate(withDuration: 0.2, animations: {
                
                // end position: bottom most position of screen
                self.tableView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            }, completion: { (finished) in
                for subview in self.view.subviews{
                    if subview.tag == 18{
                        subview.removeFromSuperview()
                    }
                        
                }
            })
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    // sort of a for loop
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LocationCell")
        let mapItem = matchingItems[indexPath.row]
        
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.placemark.title // i.e. address
        
        return cell
    }
    
    // once the specified row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let passengerCoordinate = manager?.location?.coordinate
        
        // creating annotation with captured coordinate 
        let passengerAnnotation = PassengerAnnotation(coordinate: passengerCoordinate!, key: currentUserId!)
        
        mapView.addAnnotation(PassengerAnnotation)
        
        animateTableView(shouldShow: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // hides keyboard if scroll detected
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if destinationTextField.text == ""{
            animateTableView(shouldShow: false)
        }
    }
    
    
    
}
