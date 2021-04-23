//
//  LoadPropertyListingsFromCacheUseCaseTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import XCTest
import SeLoger

class LoadPropertyListingsFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_DeliversNoPropertyListingsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_DeliversPropertyListings() {
        let (sut, store) = makeSUT()
        let propertyListings = uniqueItems()

        expect(sut, toCompleteWith: .success(propertyListings.models)) {
            store.completeRetrieval(with: propertyListings.locals)
        }
    }
    
    func test_load_deletesCacheOnretrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedPropertyListings])
    }
    
    func test_load_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = PropertyListingsStoreSpy()
        var sut: LocalPropertyListingsLoader? = LocalPropertyListingsLoader(store: store)
        
        var receivedResult = [LocalPropertyListingsLoader.LoadResult]()
        sut?.load { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalPropertyListingsLoader, store: PropertyListingsStoreSpy) {
        let store = PropertyListingsStoreSpy()
        let sut = LocalPropertyListingsLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPropertyListingsLoader, toCompleteWith expectedResult: LocalPropertyListingsLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPropertyListings), .success(expectedPropertyListings)):
                XCTAssertEqual(receivedPropertyListings, expectedPropertyListings, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }

}
