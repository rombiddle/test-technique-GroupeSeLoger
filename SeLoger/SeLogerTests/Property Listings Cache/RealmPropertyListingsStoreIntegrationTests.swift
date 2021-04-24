//
//  RealmPropertyListingsStoreIntegrationTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import XCTest
import SeLoger
import RealmSwift

class RealmPropertyListingsStoreIntegrationTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try setupEmptyStoreState()
    }
    
    override func tearDownWithError() throws {
        try undoStoreSideEffects()
        
        try super.tearDownWithError()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        expect(sut, toRetrieve: .success([]))
    }
    
    func test_retrieve_deliversPropertyListingsInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToLoad = try makeSUT()
        let listings = uniqueItems().locals

        insert(listings, to: storeToInsert)

        expect(storeToLoad, toRetrieve: .success(listings))
    }
    
    func test_insert_overridesPropertyListingsInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToOverride = try makeSUT()
        let storeToLoad = try makeSUT()

        insert(uniqueItems().locals, to: storeToInsert)

        let latestPropertyListings = uniqueItems().locals
        insert(latestPropertyListings, to: storeToOverride)

        expect(storeToLoad, toRetrieve: .success(latestPropertyListings))
    }
    
    func test_delete_deletesPropertyListingsInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToDelete = try makeSUT()
        let storeToLoad = try makeSUT()

        insert(uniqueItems().locals, to: storeToInsert)

        deleteCache(from: storeToDelete)

        expect(storeToLoad, toRetrieve: .success([]))
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> PropertyListingsStore {
        let sut = RealmPropertyListingsStore(configuration: testRealmStoreURLConfiguration())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testRealmStoreURLConfiguration() -> Realm.Configuration {
        Realm.Configuration(fileURL: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self))RealmStore")
    }
    
    private func setupEmptyStoreState() throws {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() throws {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

}
