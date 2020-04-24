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
    func addData(collectionName: String, place: Place, completionHandler: @escaping (Bool) -> Void)
    
    func getData(collectionName: String, completionHandler: @escaping (Result<[Place], Error>) -> Void)
    
    //Bool, [Place]?
}
