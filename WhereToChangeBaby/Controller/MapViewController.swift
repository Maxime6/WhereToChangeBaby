//
//  MapViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/12/2019.
//  Copyright © 2019 MaximeTanter. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var addPlaceButton: UIButton!
    
    // MARK: - Properties
    
    private var locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    var mapViewRegion: MKCoordinateRegion?
    
    private var selectedPin: MKPlacemark?
    
    var addPlaceVC: AddPlaceViewController?
    var place: Place?
    var places: [Place] = []
    
    let databaseService = DatabaseService()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationServices()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firestore.firestore().collection("Places")
            .order(by: "name")
            .addSnapshotListener { (querySnapShot, error) in
                self.places = []
                if let e = error {
                    print("There was an issue retrieving data from firestore, \(e)")
                } else {
                    if let snapShotDocuments = querySnapShot?.documents {
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            print("data: \(data)")
                            print(data["mattress protection"])
                            
                            if let changingTable = data["changing table"] as? Bool,
                                let mattress = data["mattress"] as? Bool,
                                let mattressProtection = data["mattress protection"] as? Bool,
                                let babyDiapers = data["baby diapers"] as? Bool,
                                let wipes = data["wipes"] as? Bool,
                                let childrensToilet = data["children's toilet"] as? Bool {
                                    let newAccessories = Place.Accessories(changingTable: changingTable, mattress: mattress, mattressProtection: mattressProtection, babyDiapers: babyDiapers, wipes: wipes, childrensToilet: childrensToilet)
                                    if let name = data["name"] as? String,
                                        let address = data["address"] as? String,
                                        let latitude = data["latitude"] as? Double,
                                        let longitude = data["longitude"] as? Double,
                                        let cleanliness = data["cleanliness"] as? Int,
                                        let zone = data["zone"] as? String {
                                        let newPlace = Place(name: name, address: address, latitude: latitude, longitude: longitude, zone: Place.Zone(rawValue: zone)!, cleanliness: cleanliness, accessories: newAccessories)
                                        self.places.append(newPlace)
                                        print("newplace : \(newPlace)")
                                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        let placeMark = MKPlacemark(coordinate: coordinate)
                                        self.selectedPin = placeMark
                                        let annotation = MKPointAnnotation()
                                        annotation.title = self.selectedPin?.title
                                        annotation.coordinate = coordinate
                                        self.mapView.addAnnotation(annotation)
                                        print(placeMark)

                                }
                            }
                        }
                    }
                }
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func addPlaceButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToAddPlace", sender: self)
    }
    
    @IBAction private func cancelAddPlaceToMapViewController(_ segue: UIStoryboardSegue) {
        
        if let addPlaceVC = segue.source as? AddPlaceViewController {
            addPlaceVC.createPlaceObject()
//            place = addPlaceVC.place
//            guard let placeInfos = place else { return }
            
            selectedPin = addPlaceVC.placeMark
            guard let selectedPin = selectedPin else { return }

            let annotation = MKPointAnnotation()
            annotation.title = selectedPin.title
            annotation.coordinate = selectedPin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Class Methods
    private func setUpLocationManger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
//            mapViewRegion = region
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManger()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
                
        @unknown default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddPlace" {
            let addPlaceVC = segue.destination as? AddPlaceViewController
            addPlaceVC?.mapViewRegion = mapViewRegion
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    

}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
