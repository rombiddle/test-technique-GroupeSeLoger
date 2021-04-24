//
//  RealmPropertyListingsStoreTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import XCTest
import SeLoger
import RealmSwift

class RealmPropertyListingsStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success([]))
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let listings = uniqueItems().locals
        
        insert(listings, to: sut)
        
        expect(sut, toRetrieve: .success(listings))
    }

    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert(uniqueItems().locals, to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let lastestPropertyListings = uniqueItems().locals
        let latestInsertionError = insert(lastestPropertyListings, to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
    }

    // - MARK: Helpers

    private func makeSUT(configuration: Realm.Configuration? = nil, file: StaticString = #filePath, line: UInt = #line) -> RealmPropertyListingsStore {
        let sut = RealmPropertyListingsStore(configuration: configuration ?? testRealmInMemoryConfiguration())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testRealmInMemoryConfiguration() -> Realm.Configuration {
        Realm.Configuration(inMemoryIdentifier: "\(type(of: self))Realm")
    }
    
    @discardableResult
    private func insert(_ listings: [LocalPropertyListing], to sut: RealmPropertyListingsStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        
        var insertionError: Error?
        sut.insert(listings) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    private func expect(_ sut: RealmPropertyListingsStore, toRetrieve expectedResult: PropertyListingsStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
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

}
