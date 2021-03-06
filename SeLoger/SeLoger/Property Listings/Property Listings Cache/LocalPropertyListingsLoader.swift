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
}

extension LocalPropertyListingsLoader: PropertyListingsCache {
    public typealias SaveResult = PropertyListingsCache.Result

    public func save(_ items: [PropertyListing], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedPropertyListings { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(cacheDeletionError):
                completion(.failure(cacheDeletionError))
            case .success:
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [PropertyListing], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocals()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedPropertyListings { _ in }
            default:
                break
            }
        }
    }
}

extension LocalPropertyListingsLoader: PropertyListingsLoader {
    public typealias LoadResult = PropertyListingsLoader.Result

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(propertyListings):
                completion(.success(propertyListings.toModels()))
            }
        }
    }
}

private extension Array where Element == PropertyListing {
    func toLocals() -> [LocalPropertyListing] {
        map {
            LocalPropertyListing(bedrooms: $0.bedrooms,
                                 city: $0.city,
                                 id: $0.id,
                                 area: $0.area,
                                 url: $0.url,
                                 price: $0.price,
                                 professional: $0.professional,
                                 propertyType: $0.propertyType,
                                 rooms: $0.rooms)
        }
    }
}

private extension Array where Element == LocalPropertyListing {
    func toModels() -> [PropertyListing] {
        map {
            PropertyListing(bedrooms: $0.bedrooms,
                            city: $0.city,
                            id: $0.id,
                            area: $0.area,
                            url: $0.url,
                            price: $0.price,
                            professional: $0.professional,
                            propertyType: $0.propertyType,
                            rooms: $0.rooms)        }
    }
}
