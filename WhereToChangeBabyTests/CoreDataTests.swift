//
//  CoreDataTests.swift
//  WhereToChangeBabyTests
//
//  Created by Maxime on 09/02/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import XCTest
import CoreData
@testable import WhereToChangeBaby

class CoreDataTests: XCTestCase {
    
    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhereToChangeBaby")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath:  "/dev/null")
        container.loadPersistentStores { (description, error) in
            XCTAssertNil(error)
        }
        return container
    }()
    
    private func newItem(into managedObjectContext: NSManagedObjectContext) {
        let item = Item(context: managedObjectContext)
        item.itemName = "name"
    }
    
    private func newBag(into managedObjectContext: NSManagedObjectContext) -> Bag {
        let newBag = Bag(context: managedObjectContext)
        newBag.name = "bagName"
        newItem(into: managedObjectContext)
        return newBag
    }
    
    func testCreateBagEntityInPersistentContainer() {
        let items = ["couches", "cotons"]
        let bagName = "Sac à langer"
        Bag.create(name: bagName, items: items, viewContext: mockContainer.viewContext)
        
        let bag = Bag.fetchAll(viewContext: mockContainer.viewContext).first
        XCTAssertNotNil(bag)
        XCTAssertEqual(bag?.name, "Sac à langer")
    }
    
    func testDeleteBagInPersistentContainer() {
        let _ = newBag(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        Bag.deleteEntity(name: "bagName", viewContext: mockContainer.viewContext)
        XCTAssertEqual(Bag.fetchAll(viewContext: mockContainer.viewContext), [])
    }
    
    func testChangeBagNameInPersistentContainer() {
        let bag = newBag(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        Bag.changeBagName(name: "newName", bag: bag, viewContext: mockContainer.viewContext)
        
        XCTAssertEqual(bag.name, "newName")
    }
    
    func testDeleteItemInPersistentContainer() {
        let _ = newBag(into: mockContainer.viewContext)
        try? mockContainer.viewContext.save()
        Item.deleteItemEntity(name: "name", viewContext: mockContainer.viewContext)
        
        XCTAssertEqual(newBag(into: mockContainer.viewContext).items, [])
    }

}
