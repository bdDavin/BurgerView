//
//  MapVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    
    let locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D()
    var burgerItems = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        configureLocationService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hideView()
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.3) {
            self.profileButton.layer.position.y += 128
            self.locationButton.layer.position.y += 128
            self.updateButton.layer.position.y += 128
            self.infoView.layer.position.y += self.infoView.frame.height + 20
            print(self.infoView.layer.position.y)

        }
    }
    
    func showView() {
        UIView.animate(withDuration: 0.3) {
            self.profileButton.layer.position.y -= 128
            self.locationButton.layer.position.y -= 128
            self.updateButton.layer.position.y -= 128
            self.infoView.layer.position.y -= self.infoView.frame.height + 20
            print(self.infoView.layer.position.y)
        }
    }
    
    private func configureLocationService() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func centerMapOnLocation(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error {
            print ("Error signing out: \(error)")
        }
    }
    @IBAction func profilePressed(_ sender: UIButton) {
    }
    @IBAction func myLocationPressed(_ sender: UIButton) {
    }
    @IBAction func updatePressed(_ sender: UIButton) {
    }
    
    // Search
    func findBurgerSpots() {
        mapView.removeAnnotations(mapView.annotations)
        burgerItems.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Burger"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if let results = response {
                
                if let err = error {
                    print("Error occurred in search: \(err.localizedDescription)")
                } else if results.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    
                    for item in results.mapItems {
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No Match")")
                        
                        self.burgerItems.append(item as MKMapItem)
                        print("Matching items = \(self.burgerItems.count)")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        currentCoordinate = latestLocation.coordinate

        centerMapOnLocation(with: latestLocation.coordinate)
        locationManager.stopUpdatingLocation()
        findBurgerSpots()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The auth status changed")
        if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
        centerMapOnLocation(with: view.annotation!.coordinate)
        showView()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("The annotation was deselected: \(String(describing: view.annotation?.title))")
        hideView()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view.displayPriority = .required
            view.glyphImage = UIImage(named: "burger-30")
            view.selectedGlyphImage = UIImage(named: "burger-60")
            return view
    }
    
}
