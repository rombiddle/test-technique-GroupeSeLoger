//
//  PropertyListingsLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

public protocol PropertyListingsLoader {
    typealias Result = Swift.Result<[PropertyListing], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

public protocol PropertyListingsCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ items: [PropertyListing], completion: @escaping (Result) -> Void)
    func validateCache()
}
