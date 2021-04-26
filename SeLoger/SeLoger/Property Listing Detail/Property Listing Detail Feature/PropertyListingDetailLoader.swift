//
//  PropertyListingDetailLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 25/04/2021.
//

import Foundation

public protocol PropertyListingDetailLoader {
    typealias Result = Swift.Result<PropertyListing, Error>
    
    func load(completion: @escaping (Result) -> Void)
}
