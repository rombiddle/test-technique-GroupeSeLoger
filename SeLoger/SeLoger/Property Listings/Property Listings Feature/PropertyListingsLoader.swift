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
