//
//  AddPlaceViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 18/02/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit
import MapKit

class AddPlaceViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addPlaceBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    
    // MARK: - Properties
    var mapView: MKMapView?
    private var resultSearchController: UISearchController?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        setUpPlaceSearchTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Actions
    @IBAction func addPlaceButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPlaceSearchVC(_ segue: UIStoryboardSegue) {
        if let placeSearchVC = segue.source as? PlacesSearchTableViewController {
            placeNameLabel.text = placeSearchVC.placeName
            placeAddressLabel.text = placeSearchVC.placeAddress
        }
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
        placesSearchTable?.mapView = mapView
    }
    
}
