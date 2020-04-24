//
//  DatabaseProtocol.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 13/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation
import Firebase

protocol DatabaseProtocol {
    
    // Add data to Firestore method
    func addData(collectionName: String, place: Place, completionHandler: @escaping (Bool) -> Void)
    
    // Get Data from Firestore Method
    func getData(collectionName: String, completionHandler: @escaping (Result<[Place], Error>) -> Void)
}
