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
    
    func test_deleteOnEmptyCache_retrieveEmptyCache() {
        let sut = makeSUT()
         
        deleteCache(from: sut)

        expect(sut, toRetrieve: .success([]))
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert(uniqueItems().locals, to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrieve: .success([]))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueItems().locals) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedPropertyListings { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueItems().locals) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }

    // - MARK: Helpers

    private func makeSUT(configuration: Realm.Configuration? = nil, file: StaticString = #filePath, line: UInt = #line) -> PropertyListingsStore {
        let sut = RealmPropertyListingsStore(configuration: configuration ?? testRealmInMemoryConfiguration())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testRealmInMemoryConfiguration() -> Realm.Configuration {
        Realm.Configuration(inMemoryIdentifier: "\(type(of: self))Realm")
    }
    
    @discardableResult
    private func insert(_ listings: [LocalPropertyListing], to sut: PropertyListingsStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        
        var insertionError: Error?
        sut.insert(listings) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    private func deleteCache(from sut: PropertyListingsStore) {
        let exp = expectation(description: "Wait for cache deletion")
        sut.deleteCachedPropertyListings { result in
            if case let Result.failure(error) = result {
                XCTAssertNil(error, "Expected cache deletion to succeed")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: PropertyListingsStore, toRetrieve expectedResult: PropertyListingsStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
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
