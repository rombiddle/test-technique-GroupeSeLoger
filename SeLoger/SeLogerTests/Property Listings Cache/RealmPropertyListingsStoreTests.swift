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
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .success([]))
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let listings = uniqueItems().locals
        
        insert(listings, to: sut)
        
        expect(sut, toRetrieve: .success(listings))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let listings = uniqueItems().locals
        
        insert(listings, to: sut)
        
        expect(sut, toRetrieveTwice: .success(listings))
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
    
    private func insert(_ listings: [LocalPropertyListing], to sut: RealmPropertyListingsStore) {
        let exp = expectation(description: "Wait for cache insertion")
        
        sut.insert(listings) { insertionError in
            XCTAssertNil(insertionError, "Expected property listng to be inserted successfully")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
    
    private func expect(_ sut: RealmPropertyListingsStore, toRetrieveTwice expectedResult: PropertyListingsStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

}
