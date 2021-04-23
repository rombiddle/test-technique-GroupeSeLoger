//
//  LocalPropertyListingsLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation

public class LocalPropertyListingsLoader {
    let store: PropertyListingsStore
    
    public typealias LoadResult = PropertyListingsLoader.Result
    
    public init(store: PropertyListingsStore) {
        self.store = store
    }
}

extension LocalPropertyListingsLoader {
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
        store.insert(items.toLocals()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

extension LocalPropertyListingsLoader {
    public func load(with completion: @escaping (LoadResult) -> Void) {
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

extension LocalPropertyListingsLoader {
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
