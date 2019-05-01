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
    
    //Animated view
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let locationManager = CLLocationManager()
    
    var currentCoordinate = CLLocationCoordinate2D()
    var burgerItems = [MKMapItem]()
    var reviews = [Review]()
    var selectedBurgerItem = MKMapItem()
    var selectedAnno: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedAnno == nil {
            hideView()
        } else {
            mapView.deselectAnnotation(selectedAnno, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReviews" {
            let destVC = segue.destination as! ReviewsVC
            destVC.burgerItem = selectedBurgerItem
        }
    }
    //Animations
    func hideView() {
        UIView.animate(withDuration: 0.3) {
            self.profileButton.layer.position.y += 118
            self.locationButton.layer.position.y += 118
            self.updateButton.layer.position.y += 118
            self.infoView.layer.position.y += self.infoView.frame.height - 20
        }
    }
    
    func showView() {
        UIView.animate(withDuration: 0.3) {
            self.profileButton.layer.position.y -= 118
            self.locationButton.layer.position.y -= 118
            self.updateButton.layer.position.y -= 118
            self.infoView.layer.position.y -= self.infoView.frame.height - 20
        }
    }
    //Asking for locations service if not enabled
    private func configureLocationService() {
        mapView.delegate = self
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    //Start looking for useer location
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    //Func to center map
    private func centerMapOnLocation(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Buttons
    
    @IBAction func myLocationPressed(_ sender: UIButton) {
        centerMapOnLocation(with: currentCoordinate)
        findBurgerSpots()
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        findBurgerSpots()
    }
    
    @IBAction func navigatePressed(_ sender: UIButton) {
        selectedBurgerItem.openInMaps(launchOptions: nil)
    }
    
    //MARK: - Data
    
    func getData() {
        db.collection("Reviews").whereField("burgerJointName", isEqualTo: selectedBurgerItem.name as Any).getDocuments { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            }else {
                for documents in snapshot!.documents {
                    let data = documents.data()
                    let review = Review(data: data)
                    self.reviews.append(review)
                }
            }
        }
    }
    
    //MARK: - Search
    
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
        let name = view.annotation?.title as? String
        nameLabel.text = name
        getData()

        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate)
        selectedBurgerItem = MKMapItem(placemark: placemark)
        selectedAnno = view.annotation!
        selectedBurgerItem.name = view.annotation?.title as? String
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
            view.glyphTintColor = #colorLiteral(red: 1, green: 0.8509803922, blue: 0.5568627451, alpha: 1)
            view.markerTintColor = #colorLiteral(red: 0.3803921569, green: 0.4352941176, blue: 0.2235294118, alpha: 1)
            view.glyphImage = UIImage(named: "burger-30")
            view.selectedGlyphImage = UIImage(named: "burger-60")
            return view
    }
    
}
