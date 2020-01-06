//
//  Bag.swift
//  WhereToChangeBaby
//
//  Created by Maxime on 03/01/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import Foundation
import CoreData

class Bag: NSManagedObject {
    
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Bag] {
        let request: NSFetchRequest<Bag> = Bag.fetchRequest()
        guard let bags = try? viewContext.fetch(request) else { return [] }
        return bags
    }
    
    static func create(name: String, items: [String], viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let bag = Bag(context: viewContext)
        bag.name = name
        for item in items {
            Item.create(itemName: item, bag: bag, viewContext: viewContext)
        }
        try? viewContext.save()
    }
    
}
