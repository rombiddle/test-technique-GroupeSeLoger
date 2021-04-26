//
//  PropertyListingsLoaderCacheDecorator.swift
//  SeLogerApp
//
//  Created by Romain Brunie on 25/04/2021.
//

import Foundation
import SeLoger

final class PropertyListingsLoaderCacheDecorator: PropertyListingsLoader {
    private let decoratee: PropertyListingsLoader
    private let cache: PropertyListingsCache
    
    init(decoratee: PropertyListingsLoader, cache: PropertyListingsCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            switch result {
            case let .success(propertyListings):
                self?.cache.validateCache()
                self?.cache.saveIgnoringResult(propertyListings)
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

private extension PropertyListingsCache {
    func saveIgnoringResult(_ propertyListings: [PropertyListing]) {
        save(propertyListings) { _ in }
    }
}
