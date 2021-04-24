//
//  PropertyListingsStore.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation

public protocol PropertyListingsStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[LocalPropertyListing], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    func insert(_ items: [LocalPropertyListing], completion: @escaping InsertionCompletion)
    func deleteCachedPropertyListings(completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
