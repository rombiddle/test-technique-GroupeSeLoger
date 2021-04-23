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
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    
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
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func insert(_ items: [LocalPropertyListing], completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
}
