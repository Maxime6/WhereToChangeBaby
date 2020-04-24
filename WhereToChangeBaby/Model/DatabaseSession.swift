//
//  DatabaseSession.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation
import Firebase

class DatabaseSession: DatabaseProtocol {
    
    func addData(collectionName: String, place: Place, completionHandler: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection(collectionName)
            .addDocument(data: ["latitude": place.latitude,
                                "longitude": place.longitude,
                                "name": place.name,
                                "address": place.address,
                                "cleanliness": place.cleanliness,
                                "zone": place.zone.rawValue,
                                "changing table": place.accessories.changingTable,
                                "mattress" : place.accessories.mattress,
                                "mattress protection": place.accessories.mattressProtection,
                                "baby diapers": place.accessories.babyDiapers,
                                "wipes": place.accessories.wipes,
                                "children's toilet": place.accessories.childrensToilet]) { (error) in
            if let e = error {
                print("There is an issue saving data to firestore, \(e)")
                completionHandler(false)
            } else {
                print("Success, \(place)")
                completionHandler(true)
            }
        }
    }
    
    func getData(collectionName: String, completionHandler: @escaping (Result<[Place], Error>) -> Void) {
        Firestore.firestore()
            .collection(collectionName)
            .addSnapshotListener { (querySnapShot, error) in
                var placesData = [Place]()
                if let e = error {
                    print("There was an issue retrieving data from firestore, \(e)")
                    // completionhandler
                    completionHandler(.failure(error!))
                } else {
                    if let snapShotDocuments = querySnapShot?.documents {
                        for doc in snapShotDocuments {
                            let data = doc.data()
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
                                        placesData.append(newPlace)
//                                        print("newPlace: \(newPlace)")
                                        completionHandler(.success(placesData))
                                }
                            }
                        }
                    }
                }
        }
    }
    
}
