//
//  Place.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 20/03/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation

struct Place {
    let name: String
    var address: String
    let latitude: Double
    let longitude: Double
    
    enum Zone: String {
        case femme = "femme", homme = "homme", mixte = "mixte"
    }
    
    let zone: Zone
    
    let cleanliness: Int
    
    let accessories: Accessories
    
    struct Accessories {
        let changingTable: Bool
        let mattress: Bool
        let mattressProtection: Bool
        let babyDiapers: Bool
        let wipes: Bool
        let childrensToilet: Bool
    }

}
