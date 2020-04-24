//
//  AddPlaceViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 18/02/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddPlaceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var addPlaceBarButtonItem: UIBarButtonItem!
    @IBOutlet weak private var placeNameLabel: UILabel!
    @IBOutlet weak private var placeAddressLabel: UILabel!
    @IBOutlet weak private var zoneSegmentedControl: UISegmentedControl!
    @IBOutlet weak private var cleanlinessSlider: UISlider!
    @IBOutlet private var accessoriesSwitchCollection: [UISwitch]!
    
    // MARK: - Properties
    
    let databaseService = DatabaseService()
    
    var mapViewRegion: MKCoordinateRegion?
    private var resultSearchController: UISearchController?
    
    var placeMark: MKPlacemark?
    
    var place: Place?
    private var placeAccessories: Place.Accessories?
    private var sliderValue = 5
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        setUpPlaceSearchTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Actions
    
    @IBAction private func cancelPlaceSearchVC(_ segue: UIStoryboardSegue) {
        if let placeSearchVC = segue.source as? PlacesSearchTableViewController {
            placeNameLabel.text = placeSearchVC.placeName
            placeAddressLabel.text = placeSearchVC.placeAddress
            placeMark = placeSearchVC.placeMark
        }
    }
    
    @IBAction func sliderInteraction(_ sender: Any) {
        let value = cleanlinessSlider.value
        sliderValue = Int(value)
    }
    
    // MARK: - Class Methods
    
    private func setUpPlaceSearchTable() {
        let placesSearchTable = storyboard?.instantiateViewController(identifier: "PlacesSearchTableViewController") as? PlacesSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: placesSearchTable)
        resultSearchController?.searchResultsUpdater = placesSearchTable
        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Recherchez une adresse"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func createPlaceObject() {
        guard let placeName = placeNameLabel.text else { return }
        guard let placeAdress = placeAddressLabel.text else { return }
        guard let latitude = placeMark?.coordinate.latitude else { return }
        guard let longitude = placeMark?.coordinate.longitude else { return }
        let cleanlinessValue = sliderValue
        
        let zoneIndex = zoneSegmentedControl.selectedSegmentIndex
        var zone = Place.Zone.femme
        switch zoneIndex {
        case 0:
            zone = .femme
        case 1:
            zone = .homme
        case 2:
            zone = .mixte
        default:
            break
        }

        placeAccessories = Place.Accessories(changingTable: accessoriesSwitchCollection[0].isOn, mattress: accessoriesSwitchCollection[1].isOn, mattressProtection: accessoriesSwitchCollection[2].isOn, babyDiapers: accessoriesSwitchCollection[3].isOn, wipes: accessoriesSwitchCollection[4].isOn, childrensToilet: accessoriesSwitchCollection[5].isOn)

        guard let accessories = placeAccessories else { return }
        
        place = Place(name: placeName, address: placeAdress, latitude: latitude, longitude: longitude, zone: zone, cleanliness: cleanlinessValue, accessories: accessories)
        
        guard let place = place else { return }

        savePlaceObject(place: place)
        
    }
    
    private func savePlaceObject(place: Place) {
        databaseService.saveData(collectionName: "Places", place: place) { success in
            if success {
                print("Success saving data to firestore.")
            } else {
                print("error")
            }
        }
    }
    
}
