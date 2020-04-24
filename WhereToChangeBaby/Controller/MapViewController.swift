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

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var addPlaceButton: UIButton!
    
    // MARK: - Properties
    
    private var locationManager = CLLocationManager()
    private let regionInMeters: Double = 5000
    var mapViewRegion: MKCoordinateRegion?
    
    private var selectedPin: MKPlacemark?
    
    var addPlaceVC: AddPlaceViewController?
    var placeInfos: Place?
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
        
        databaseService.getPlacesData(collectionName: "Places") { (result) in
            switch result {
            case .success(let places):
                self.places = places
                for place in self.places {
                    let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                    let annotation = PlaceAnnotation()
                    annotation.title = place.name
                    annotation.coordinate = coordinate
                    annotation.place = place
                    self.mapView.addAnnotation(annotation)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        } else if segue.identifier == "segueToPlaceDetails" {
            let placeDetailsVC = segue.destination as? PlaceDetailsControllerViewController
            placeDetailsVC?.place = placeInfos
        }
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {

          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
            let infosButton = UIButton(type: .detailDisclosure)
          view.rightCalloutAccessoryView = infosButton
            view.glyphImage = UIImage(named: "baby")
            view.glyphImage?.withTintColor(UIColor(displayP3Red: 175/255, green: 82/255, blue: 22/255, alpha: 0.85))
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let place = view.annotation as? PlaceAnnotation
        placeInfos = place?.place
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "segueToPlaceDetails", sender: self)
        }
        
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
