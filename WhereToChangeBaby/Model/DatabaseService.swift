//
//  DatabaseService.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService {
    private var databaseSession: DatabaseSession
    
    init (databaseSession: DatabaseSession = DatabaseSession()) {
        self.databaseSession = databaseSession
    }
    
    // Saving data to Firestore
    func saveData(collectionName: String, place: Place, completionHandler: @escaping (Bool) -> Void) {
        databaseSession.addData(collectionName: collectionName, place: place, completionHandler: completionHandler)
    }
    
    // Get data from firestore database
    func getPlacesData(collectionName: String, completionHandler: @escaping (Result<[Place], Error>) -> Void) {
        databaseSession.getData(collectionName: collectionName, completionHandler: completionHandler)
    }

    
}
