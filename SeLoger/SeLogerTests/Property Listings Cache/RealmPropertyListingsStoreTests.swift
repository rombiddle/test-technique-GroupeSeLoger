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
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case .success:
                break
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.success, .success):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(firstResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let listings = uniqueItems().locals
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(listings) { insertionError in
            XCTAssertNil(insertionError, "Expected property listings to be inserted successfully")
            
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .success(retrievedListings):
                    XCTAssertEqual(retrievedListings, listings)
                    
                default:
                    XCTFail("Expected found result with property listings \(listings), got \(retrieveResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
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

}
