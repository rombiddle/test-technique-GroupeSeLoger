//
//  RealmPropertyListingsStore.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import RealmSwift

public class RealmPropertyListingsStore {
    private let configuration: Realm.Configuration
        
    public init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    public func retrieve(completion: @escaping PropertyListingsStore.RetrievalCompletion) {
        do {
            let realm = try Realm(configuration: self.configuration)
            let cache = realm.objects(RealmPropertyListingsCache.self).first
            if let cache = cache {
                let localPropertyListings = try cache.realmPropertyListingstoLocals()
                completion(.success(localPropertyListings))
            } else {
                completion(.success([]))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    public func insert(_ items: [LocalPropertyListing], completion: @escaping PropertyListingsStore.InsertionCompletion) {
        do {
            let realm = try Realm(configuration: self.configuration)
            try realm.write {
                let propertyListings = items.map { RealmPropertyListings(bedrooms: $0.bedrooms,
                                                                         city: $0.city,
                                                                         id: $0.id,
                                                                         area: $0.area,
                                                                         url: $0.url,
                                                                         price: $0.price,
                                                                         professional: $0.professional,
                                                                         propertyType: $0.propertyType,
                                                                         rooms: $0.rooms)
                }
                let cache = RealmPropertyListingsCache(listings: propertyListings)
                realm.add(cache, update: .modified)
            }
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    public func deleteCachedPropertyListings(completion: @escaping PropertyListingsStore.DeletionCompletion) {
        completion(nil)
    }

}
