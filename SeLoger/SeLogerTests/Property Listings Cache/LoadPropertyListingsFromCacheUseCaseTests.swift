//
//  LoadPropertyListingsFromCacheUseCaseTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 22/04/2021.
//

import XCTest

class LocalPropertyListingsLoader {
    let store: PropertyListingsStore
    
    init(store: PropertyListingsStore) {
        self.store = store
    }
}

class PropertyListingsStore {
    var deleteCachedPropertyListingsCallCount: Int = 0
}

class LoadPropertyListingsFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = PropertyListingsStore()
        _ = LocalPropertyListingsLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedPropertyListingsCallCount, 0)
    }

}
