//
//  LocalPropertyListingsLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation

public class LocalPropertyListingsLoader {
    let store: PropertyListingsStore
    
    public init(store: PropertyListingsStore) {
        self.store = store
    }
    
    public func save(_ items: [PropertyListing], completion: @escaping (Error?) -> Void) {
        store.deleteCachedPropertyListings { [weak self] error in
            guard let self = self else { return }

            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [PropertyListing], with completion: @escaping (Error?) -> Void) {
        store.insert(items) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
