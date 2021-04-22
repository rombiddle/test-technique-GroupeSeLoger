//
//  LoadPropertyListingsFromCacheUseCaseTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 22/04/2021.
//

import XCTest
import SeLoger

class LocalPropertyListingsLoader {
    let store: PropertyListingsStore
    
    init(store: PropertyListingsStore) {
        self.store = store
    }
    
    func save(_ items: [PropertyListing]) {
        store.deleteCachedPropertyListings()
    }
}

class PropertyListingsStore {
    var deleteCachedPropertyListingsCallCount: Int = 0
    
    func deleteCachedPropertyListings() {
        deleteCachedPropertyListingsCallCount += 1
    }
}

class LoadPropertyListingsFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedPropertyListingsCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedPropertyListingsCallCount, 1)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalPropertyListingsLoader, store: PropertyListingsStore) {
        let store = PropertyListingsStore()
        let sut = LocalPropertyListingsLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }

    private func uniqueItem() -> PropertyListing {
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
    
    private func anyInt() -> Int {
        Int.random(in: 0..<100)
    }

}
