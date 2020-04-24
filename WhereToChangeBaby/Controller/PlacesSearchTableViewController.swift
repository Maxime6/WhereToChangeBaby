//
//  PlacesSearchTableViewController.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 21/02/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import UIKit
import MapKit

class PlacesSearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var matchingItems: [MKMapItem] = []
    var placeName = ""
    var placeAddress = ""
    var placeMark: MKPlacemark?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Extensions

extension PlacesSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension PlacesSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
        return cell
    }
}

extension PlacesSearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        placeMark = selectedItem
        guard let placeName = selectedItem.name else { return }
        self.placeName = placeName
        placeAddress = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        performSegue(withIdentifier: "cancelPlaceSearchVC", sender: self)
    }
}
