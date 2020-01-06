//
//  Item.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 05/01/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    static func create(itemName: String, bag: Bag, viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let bagItem = Item(context: viewContext)
        bagItem.itemName = itemName
        bagItem.bag = bag
    }
    
}
