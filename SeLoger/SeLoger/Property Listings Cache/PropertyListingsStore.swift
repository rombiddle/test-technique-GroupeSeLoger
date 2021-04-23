//
//  PropertyListingsStore.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation

public protocol PropertyListingsStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func insert(_ items: [LocalPropertyListing], completion: @escaping InsertionCompletion)
    func deleteCachedPropertyListings(completion: @escaping DeletionCompletion)
    func retrieve()
}
