//
//  PropertyListingsStoreSpy.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import SeLoger

class PropertyListingsStoreSpy: PropertyListingsStore  {
    enum ReceivedMessage: Equatable {
        case deleteCachedPropertyListings
        case insert([LocalPropertyListing])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()

    func deleteCachedPropertyListings(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCachedPropertyListings)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func insert(_ items: [LocalPropertyListing], completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success([]))
    }
    
    func completeRetrieval(with propertyListings: [LocalPropertyListing], at index: Int = 0) {
        retrievalCompletions[index](.success(propertyListings))
    }
}
