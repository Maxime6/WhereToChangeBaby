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

protocol HandleMapSearch {
    func dropPinZoomIn(placeMark: MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var addPlaceInfosContainerView: UIView!
    
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    
    private var selectedPin: MKPlacemark?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationServices()
        addPlaceInfosContainerView.isHidden = true
        
    }
    
    // MARK: - Actions
    @IBAction func addPlaceButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToAddPlace", sender: self)
    }
    
    @IBAction func cancelAddPlaceToMapViewController(_ segue: UIStoryboardSegue) {
        
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
            addPlaceVC?.mapView = mapView
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

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placeMark: MKPlacemark) {
        selectedPin = placeMark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.coordinate
        annotation.title = placeMark.name
        if let city = placeMark.locality, let state = placeMark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placeMark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
