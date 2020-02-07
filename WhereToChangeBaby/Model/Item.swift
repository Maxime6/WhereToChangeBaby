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

    static func deleteItemEntity(name: String, viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        guard let items = try? viewContext.fetch(request) else { return }
        guard let item = items.first else { return }
        viewContext.delete(item)
        try? viewContext.save()
    }
    
}
