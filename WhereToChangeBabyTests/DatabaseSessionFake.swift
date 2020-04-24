//
//  DatabaseSessionFake.swift
//  WhereToChangeBabyTests
//
//  Created by Maxime on 19/04/2020.
//  Copyright © 2020 MaximeTanter. All rights reserved.
//

import XCTest
@testable import WhereToChangeBaby

final class DatabaseServiceTests: XCTestCase {
    
    private class DatabaseStub: DatabaseSession {
        
        private let placesResult: Result<[Place], Error>
        
        init(_ placesData: [Place]) {
            self.placesResult = .success(placesData)
        }
        
        init(_ error: Error) {
            self.placesResult = .failure(error)
        }
        
        override func addData(collectionName: String, place: Place, completionHandler: @escaping (Bool) -> Void) {
            completionHandler(true)
        }
        
        override func getData(collectionName: String, completionHandler: @escaping (Result<[Place], Error>) -> Void) {
            completionHandler(placesResult)
        }
    }
    
    enum TestError: Error {
        case invalidCollectionName
    }
    
    func testGetPlacesData_WhenCollectionNameIsCorrect_ThenShouldReturnPlacesData() {
        guard let zone1 = Place.Zone(rawValue: "Homme") else { return }
        let accessories1 = Place.Accessories(changingTable: true, mattress: true, mattressProtection: true, babyDiapers: false, wipes: false, childrensToilet: false)
        let place1 = Place(name: "Lorient", address: "Rue Professeur Lépine", latitude: -3.0, longitude: -4.0, zone: zone1, cleanliness: 7, accessories: accessories1)
        
        guard let zone2 = Place.Zone(rawValue: "Mixte") else { return }
        let accessories2 = Place.Accessories(changingTable: false, mattress: false, mattressProtection: false, babyDiapers: true, wipes: true, childrensToilet: true)
        let place2 = Place(name: "Vannes", address: "Rue de Limoges", latitude: -5.0, longitude: -6.0, zone: zone2, cleanliness: 4, accessories: accessories2)
        
        let sut: DatabaseService = DatabaseService(databaseSession: DatabaseStub([place1, place2]))
        let collectionName = "Places"
        let expectation = XCTestExpectation(description: "Wait for queue change")
        sut.getPlacesData(collectionName: collectionName) { (result) in
            guard case .success(let placesData) = result else {
                XCTFail("Get palces data success tests fails")
                return
            }
            XCTAssertTrue(placesData == [place1, place2])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlacesData_WhenCollectionNameIsIncorrect_ThenShouldReturnError() {
        
        let sut: DatabaseService = DatabaseService(databaseSession: DatabaseStub(TestError.invalidCollectionName))
        let collectionName = "InvalidCollectionName"
        let expectation = XCTestExpectation(description: "Wait for queue change")
        sut.getPlacesData(collectionName: collectionName) { (result) in
            guard case .failure(let error) = result else {
                XCTFail("Get places data success tests fails")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
//    func testSaveData_WhenDataIsCorrect_ThenSouldSaveData() {
//        guard let zone1 = Place.Zone(rawValue: "Homme") else { return }
//        let accessories1 = Place.Accessories(changingTable: true, mattress: true, mattressProtection: true, babyDiapers: false, wipes: false, childrensToilet: false)
//        let place1 = Place(name: "Lorient", address: "Rue Professeur Lépine", latitude: -3.0, longitude: -4.0, zone: zone1, cleanliness: 7, accessories: accessories1)
//        
//        let sut: DatabaseService = DatabaseService(databaseSession: DatabaseStub([]))
//        let collectionName = "Places"
//        let expectation = XCTestExpectation(description: "Wait for queue change")
//        sut.saveData(collectionName: collectionName, place: place1) { (result) in
//            guard case .success(let place) = result else {
//                XCTFail("Saving data success tests fails")
//                return
//            }
//            XCTAssertTrue(place == [place1])
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.01)
//    }

}
