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
            } else {
                print("Success, \(place)")
            }
        }
    }
    
    func getData(collectionName: String, completionHandler: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("places")
            .addSnapshotListener { (querySnapShot, error) in
                var places = [Place]()
                if let e = error {
                    print("Error retrieving data from Firestore, \(e)")
                } else {
                    if let snapShotDocuments = querySnapShot?.documents {
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            guard let name = data["name"] as? String else { return }
                            guard let address = data["address"] as? String else { return }
                            guard let latitude = data["latitude"] as? Double else { return }
                            guard let longitude = data["longitude"] as? Double else { return }
                            guard let zone = data["zone"] as? Place.Zone else { return }
                            guard let cleanliness = data["cleanliness"] as? Int else { return }
                            guard let changingTable = data["changing table"] as? Bool else { return }
                            guard let mattress = data["mattress"] as? Bool else { return }
                            guard let mattressProtection = data["mattressProtection"] as? Bool else { return }
                            guard let babyDiapers = data["baby diapers"] as? Bool else { return }
                            guard let wipes = data["wipes"] as? Bool else { return }
                            guard let childrensToilet = data["children's toilet"] as? Bool else { return }
                            let newAccessories = Place.Accessories(changingTable: changingTable, mattress: mattress, mattressProtection: mattressProtection, babyDiapers: babyDiapers, wipes: wipes, childrensToilet: childrensToilet)
                            let newPlace = Place(name: name, address: address, latitude: latitude, longitude: longitude, zone: zone, cleanliness: cleanliness, accessories: newAccessories)

                            places.append(newPlace)
                            
                        }
                    }
                }
            }
    }
    
}
