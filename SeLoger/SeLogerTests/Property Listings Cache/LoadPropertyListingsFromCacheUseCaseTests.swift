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
        store.deleteCachedPropertyListings { [unowned self] error in
            if error == nil {
                self.store.insert(items)
            }
        }
    }
}

class PropertyListingsStore {
    typealias DeletionCompletion = (Error?) -> Void
    enum ReceivedMessage: Equatable {
        case deleteCachedPropertyListings
        case insert([PropertyListing])
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedPropertyListings(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCachedPropertyListings)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [PropertyListing]) {
        receivedMessages.append(.insert(items))
    }
}

class LoadPropertyListingsFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPropertyListings])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPropertyListings])
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPropertyListings, .insert(items)])
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
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

}
