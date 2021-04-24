//
//  LocalSharedTestHelpers.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import XCTest
import SeLoger

extension XCTestCase {
    func uniqueItems() -> (models: [PropertyListing], locals: [LocalPropertyListing]) {
        let items = [uniqueItem(), uniqueItem()]
        let localItems = items.map { item in
            return LocalPropertyListing(bedrooms: item.bedrooms,
                                        city: item.city,
                                        id: item.id,
                                        area: item.area,
                                        url: item.url,
                                        price: item.price,
                                        professional: item.professional,
                                        propertyType: item.propertyType,
                                        rooms: item.rooms)
        }
        return (items, localItems)
    }

    func uniqueItem() -> PropertyListing {
        PropertyListing(bedrooms: 0,
                        city: "any city",
                        id: anyInt(),
                        area: 2.0,
                        url: nil,
                        price: 12,
                        professional: "any professional",
                        propertyType: "any propertyType",
                        rooms: 4)
    }

    func anyInt() -> Int {
        Int.random(in: 0..<100)
    }

    func expect(_ sut: PropertyListingsStore, toRetrieve expectedResult: PropertyListingsStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(expected, retrieved)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
